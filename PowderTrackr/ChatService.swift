import Amplify
import Chat
import Combine
import UIKit

public protocol ChatServiceProtocol: AnyObject {
    var messagesPublisher: AnyPublisher<[Chat.Message]?, Never> { get }
    var chatNotificationPublisher: AnyPublisher<[String]?, Never> { get }
    
    func sendMessage(message: Chat.Message, recipient: String) async
    func queryChat(recipient: String) async
    func updateMessageStatus(recipient: String) async
    func chatNotifications() async
}

final class ChatService {
    private let messages: CurrentValueSubject<[Chat.Message]?, Never> = .init(nil)
    private let chatNotifications: CurrentValueSubject<[String]?, Never> = .init(nil)
    private var chatId: String = ""
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
    
    // TODO: ENDPOINT, SEND MESSAGE
    func sendMessage(message: Chat.Message, recipient: String) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let queryResult = try await Amplify.API.query(request: .list(PersonalChat.self))
            
            var result = try queryResult.get().elements
            
            let currentChatIndex = result.firstIndex { chat in
                if let participants = chat.participants {
                    if participants.contains(recipient) && participants.contains(user.userId) {
                        return true
                    }
                }
                return false
            }
            guard let index = currentChatIndex else { return }
            
            result[index].messages?.append(
                Message(
                    id: message.id,
                    sender: user.userId,
                    date: dateFormatter.string(from: Date()),
                    text: message.text,
                    isPhoto: false,
                    isSeen: false
                )
            )
            
            _ = try await Amplify.API.mutate(request: .update(result[index]))
            await queryChat(recipient: recipient)
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }
    
    func queryChat(recipient: String) async {
        do {
            if chatId == "" {
                chatId = recipient
            }
            if chatId != recipient {
                messages.send([])
                chatId = recipient
            }
            let user = try await Amplify.Auth.getCurrentUser()
            
            let chats = DefaultAPI.personalChatsGet { data, error in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    let currentChat: PersonalChat? = data?.first { chat in
                        if let participants = chat.participants {
                            if participants.contains(recipient) && participants.contains(user.userId) {
                                return true
                            }
                        }
                        return false
                    }
                    var currentMessages: [Chat.Message] = self.messages.value ?? []
                    if let chat = currentChat {
                        chat.messages?.forEach { message in
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
                                            isCurrentUser: user.userId == message.sender),
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
            
        } catch {
            print("Can not retrieve messages: error: \(error)")
        }
    }
    
    func updateMessageStatus(recipient: String) async {
        do {
            var currentChatIndex = -1
            let user = try await Amplify.Auth.getCurrentUser()
            let queryResult = try await Amplify.API.query(request: .list(PersonalChat.self))
            
            let chats = DefaultAPI.personalChatsGet { data, error in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    guard var data else { return }
                    currentChatIndex = data.firstIndex { chat in
                        if let participants = chat.participants {
                            if participants.contains(recipient) && participants.contains(user.userId) {
                                return true
                            }
                        }
                        return false
                    } ?? -1
                    
                    if currentChatIndex == -1 { return }

                    for messageDx in 0..<(data[currentChatIndex].messages?.count ?? 0) {
                        if data[currentChatIndex].messages?[messageDx].sender == recipient {
                            data[currentChatIndex].messages?[messageDx].isSeen = true
                        }
                    }
                    let msg = data[currentChatIndex].messages?.map { message in
                        Chat.Message(
                            id: message.id,
                            user: User(
                                id: UUID().uuidString,
                                name: "",
                                avatarURL: nil,
                                isCurrentUser: user.userId == message.sender),
                            status: message.isSeen ? Chat.Message.Status.read : Chat.Message.Status.sent,
                            createdAt: self.dateFormatter.date(from: message.date) ?? Date(),
                            text: message.text
                        )
                    }
                    self.messages.send(msg)
                }
            }
            // TODO: ENDPOINT TO UPDATE MESSAGE DX
//            _ = try await Amplify.API.mutate(request: .update(data[currentChatIndex]))
            await self.queryChat(recipient: recipient)
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }
    
    func chatNotifications() async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            
            DefaultAPI.personalChatsGet { data, error in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    var notifications: Set<String> = []
                    
                    data?.forEach { chat in
                        if let participants = chat.participants {
                            if participants.contains(user.userId) {
                                chat.messages?.forEach { message in
                                    if !message.isSeen && message.sender != user.userId {
                                        notifications.insert(message.sender)
                                    }
                                }
                            }
                        }
                    }
                    self.chatNotifications.send(Array(notifications))
                }
            }
        } catch {
            print("Error in chatNotification")
        }
    }
}
