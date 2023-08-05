import Chat
import Combine
import SwiftUI

extension PowderTrackrChatView {
    final class ViewModel: ObservableObject {
        @Published var messages: [Chat.Message] = []
        @Published var chat: String = ""

        private let chatService: ChatServiceProtocol
        private let chatID: String

        private var cancellables: Set<AnyCancellable> = []

        init(
            chatService: ChatServiceProtocol,
            chatID: String
        ) {
            self.chatService = chatService
            self.chatID = chatID
            initBindings()
            Task {
                await chatService.queryMessages()
            }
        }

        func initBindings() {
            chatService.messagesPublisher
                .sink { _ in
                } receiveValue: { [weak self] messages in
                    self?.messages = messages ?? []
                }
                .store(in: &cancellables)
        }

        func sendMessage(draftMessage: Chat.DraftMessage) {
            let message = Chat.Message(
                id: UUID().uuidString,
                user: .init(id: "123", name: "Me", avatarURL: nil, isCurrentUser: true),
                text: draftMessage.text
            )
            print(message)
            Task {
               await chatService.sendMessage(message: message)
            }
        }
     }
}
