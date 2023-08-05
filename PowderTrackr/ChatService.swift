import Amplify
import Chat
import Combine
import UIKit

public protocol ChatServiceProtocol: AnyObject {
    var messagesPublisher: AnyPublisher<[Chat.Message]?, Never> { get }

    func sendMessage(message: Chat.Message) async
    func queryMessages() async
}

final class ChatService {
    private let messages: CurrentValueSubject<[Chat.Message]?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = []
}

extension ChatService: ChatServiceProtocol {
    var messagesPublisher: AnyPublisher<[Chat.Message]?, Never> {
        messages
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func sendMessage(message: Chat.Message) async {
        var currentMessages = messages.value
        currentMessages?.append(message)
        messages.send(currentMessages)
    }

    func queryMessages() async {
        print("query")
        var currentMessages: [Chat.Message] = []
        currentMessages.append(Chat.Message(id: "123", user: User(id: "123", name: "Dominik", avatarURL: nil, isCurrentUser: true), text: "Szia"))
        currentMessages.append(Chat.Message(id: "124", user: User(id: "124", name: "Koszti", avatarURL: nil, isCurrentUser: false), text: "Hali"))
        print("queryMessages", currentMessages)
        messages.send(currentMessages)
    }

}
