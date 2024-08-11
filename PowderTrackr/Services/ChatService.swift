import Combine
import ExyteChat
import SwiftUI
import UIKit

// sourcery: mock
public protocol ChatServiceProtocol: AnyObject {
    var messagesPublisher: AnyPublisher<[ExyteChat.Message]?, Never> { get }
    var chatNotificationPublisher: AnyPublisher<[String]?, Never> { get }
    var networkErrorPublisher: AnyPublisher<ToastModel?, Never> { get }
    var lastMessagesPublisher: AnyPublisher<[SocialView.LastMessageModel]?, Never> { get }

    func sendMessage(message: ExyteChat.Message, recipient: String)
    func queryChat(recipient: String)
    func updateMessageStatus(recipient: String)
    func getChatNotifications()
}

final class ChatService {
    var userID: String {
        UserDefaults(suiteName: "group.koszti.storedData")?.string(forKey: "id") ?? ""
    }
    private let messages: CurrentValueSubject<[ExyteChat.Message]?, Never> = .init(nil)
    private let chatNotifications: CurrentValueSubject<[String]?, Never> = .init(nil)
    private let lastMessages: CurrentValueSubject<[SocialView.LastMessageModel]?, Never> = .init(nil)
    private var chatId: String = ""
    private var chatRoomID: String = ""
    private var cancellables: Set<AnyCancellable> = []
    private let networkError: CurrentValueSubject<ToastModel?, Never> = .init(nil)
    let dateFormatter = DateFormatter()

    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
}

extension ChatService: ChatServiceProtocol {
    var networkErrorPublisher: AnyPublisher<ToastModel?, Never> {
        networkError
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var messagesPublisher: AnyPublisher<[ExyteChat.Message]?, Never> {
        messages
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var chatNotificationPublisher: AnyPublisher<[String]?, Never> {
        chatNotifications
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var lastMessagesPublisher: AnyPublisher<[SocialView.LastMessageModel]?, Never> {
        lastMessages
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func sendMessage(message: ExyteChat.Message, recipient: String) {
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
                DefaultAPI.personalChatsPut(personalChat: chat) { _, error in
                    if let error = error {
                        print("Error: \(error)")
                        self.networkError.send(.init(title: "An issue occured while sending message", type: .error))
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

        DefaultAPI.personalChatsGet { data, error in
            if error != nil {
                self.networkError.send(.init(title: "An issue occured while loading your messages", type: .error))
            } else {
                let currentChat: PersonalChat? = data?.first { chat in
                    let participants = chat.participants
                    if participants.contains(recipient) && participants.contains(self.userID) {
                        return true
                    }
                    return false
                }
                self.chatRoomID = currentChat?.id ?? ""
                var currentMessages: [ExyteChat.Message] = self.messages.value ?? []
                if let chat = currentChat {
                    chat.messages.forEach { message in
                        if !currentMessages.contains(where: { currentMessage in
                            currentMessage.id == message.id
                        }) {
                            currentMessages.append(
                                ExyteChat.Message(
                                    id: message.id,
                                    user: ExyteChat.User(
                                        id: UUID().uuidString,
                                        name: "",
                                        avatarURL: nil,
                                        isCurrentUser: self.userID == message.sender
                                    ),
                                    status: message.isSeen ? ExyteChat.Message.Status.read : ExyteChat.Message.Status.sent,
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
                    if data[currentChatIndex].messages[messageDx].sender != self.userID {
                        data[currentChatIndex].messages[messageDx].isSeen = true
                    }
                }
                let msg = data[currentChatIndex].messages.map { message in
                    ExyteChat.Message(
                        id: message.id,
                        user: ExyteChat.User(
                            id: UUID().uuidString,
                            name: "",
                            avatarURL: nil,
                            isCurrentUser: self.userID == message.sender
                        ),
                        status: message.isSeen ? ExyteChat.Message.Status.read : ExyteChat.Message.Status.sent,
                        createdAt: self.dateFormatter.date(from: message.date) ?? Date(),
                        text: message.text
                    )
                }
                self.messages.send(msg)
                DefaultAPI.personalChatsPut(personalChat: data[currentChatIndex]) { _, _ in }
            }
        }
    }

    func getChatNotifications() {
        DefaultAPI.personalChatsGet { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                var notifications: Set<String> = []
                var lastMessages: [SocialView.LastMessageModel] = []

                data?.forEach { chat in
                    let participants = chat.participants
                    if participants.contains(self.userID) {
                        chat.messages.forEach { message in
                            if !message.isSeen && message.sender != self.userID {
                                notifications.insert(message.sender)
                            }
                        }
                        let recipient: String = participants.first { $0 != self.userID } ?? ""
                        lastMessages.append(.init(id: recipient, message: chat.messages.last))
                    }
                }
                self.chatNotifications.send(Array(notifications))
                self.lastMessages.send(lastMessages)
            }
        }
    }
}
