import Amplify
import Chat
import Combine
import UIKit

public protocol ChatServiceProtocol: AnyObject {
    var messagesPublisher: AnyPublisher<[Chat.Message]?, Never> { get }
    var chatNotificationPublisher: AnyPublisher<[String]?, Never> { get }
    
    func sendMessage(message: Chat.Message, recipient: String)
    func queryChat(recipient: String)
    func updateMessageStatus(recipient: String)
    func getChatNotifications()
}

final class ChatService {
    private let userID: String = UserDefaults.standard.string(forKey: "id") ?? ""
    private let messages: CurrentValueSubject<[Chat.Message]?, Never> = .init(nil)
    private let chatNotifications: CurrentValueSubject<[String]?, Never> = .init(nil)
    private var chatId: String = ""
    private var chatRoomID: String = ""
    private var cancellables: Set<AnyCancellable> = []
    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
}

extension ChatService: ChatServiceProtocol {
    var messagesPublisher: AnyPublisher<[Chat.Message]?, Never> {
        messages
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var chatNotificationPublisher: AnyPublisher<[String]?, Never> {
        chatNotifications
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func sendMessage(message: Chat.Message, recipient: String) {
        DefaultAPI.personalChatsIdGet(id: chatRoomID) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                guard var chat = data else { return }
                
                chat.messages.append(
                    Message(
                        id: message.id,
                        sender: self.userID,
                        date: self.dateFormatter.string(from: Date()),
                        text: message.text,
                        isPhoto: false,
                        isSeen: false
                    )
                )
                DefaultAPI.personalChatsPut(personalChat: chat) { data, error in
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                    }
                }
                guard var messages = self.messages.value else { return }
                messages.append(message)
                self.messages.send(messages)
            }
        }
    }
    
    func queryChat(recipient: String) {
        if chatId == "" {
            chatId = recipient
        }
        if chatId != recipient {
            messages.send([])
            chatId = recipient
        }
        
        let chats = DefaultAPI.personalChatsGet { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                let currentChat: PersonalChat? = data?.first { chat in
                    let participants = chat.participants
                    if participants.contains(recipient) && participants.contains(self.userID) {
                        return true
                    }
                    return false
                }
                
                self.chatRoomID = currentChat?.id ?? ""
                var currentMessages: [Chat.Message] = self.messages.value ?? []
                if let chat = currentChat {
                    chat.messages.forEach { message in
                        if !currentMessages.contains(where: { currentMessage in
                            currentMessage.id == message.id
                        }) {
                            currentMessages.append(
                                Chat.Message(
                                    id: message.id,
                                    user: User(
                                        id: UUID().uuidString,
                                        name: "",
                                        avatarURL: nil,
                                        isCurrentUser: self.userID == message.sender),
                                    status: message.isSeen ? Chat.Message.Status.read : Chat.Message.Status.sent,
                                    createdAt: self.dateFormatter.date(from: message.date) ?? Date(),
                                    text: message.text
                                )
                            )
                        }
                    }
                }
                self.messages.send(currentMessages)
            }
        }
    }
    
    func updateMessageStatus(recipient: String) {
        var currentChatIndex = -1
        
        DefaultAPI.personalChatsGet { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                guard var data else { return }
                currentChatIndex = data.firstIndex { chat in
                    let participants = chat.participants
                    if participants.contains(recipient) && participants.contains(self.userID) {
                        return true
                    }
                    return false
                } ?? -1
                
                if currentChatIndex == -1 { return }
                
                for messageDx in .zero..<(data[currentChatIndex].messages.count) {
                    if data[currentChatIndex].messages[messageDx].sender == recipient {
                        data[currentChatIndex].messages[messageDx].isSeen = true
                    }
                }
                let msg = data[currentChatIndex].messages.map { message in
                    Chat.Message(
                        id: message.id,
                        user: User(
                            id: UUID().uuidString,
                            name: "",
                            avatarURL: nil,
                            isCurrentUser: self.userID == message.sender),
                        status: message.isSeen ? Chat.Message.Status.read : Chat.Message.Status.sent,
                        createdAt: self.dateFormatter.date(from: message.date) ?? Date(),
                        text: message.text
                    )
                }
                self.messages.send(msg)
            }
        }
    }
    
    func getChatNotifications() {
        DefaultAPI.personalChatsGet { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                var notifications: Set<String> = []
                
                data?.forEach { chat in
                    let participants = chat.participants
                    if participants.contains(self.userID) {
                        chat.messages.forEach { message in
                            if !message.isSeen && message.sender != self.userID {
                                notifications.insert(message.sender)
                            }
                        }
                    }
                }
                self.chatNotifications.send(Array(notifications))
            }
        }
    }
}
