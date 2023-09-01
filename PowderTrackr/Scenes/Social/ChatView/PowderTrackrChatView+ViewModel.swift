import Chat
import Combine
import SwiftUI

extension PowderTrackrChatView {
    final class ViewModel: ObservableObject {
        @Published var messages: [Chat.Message] = []
        @Published var chat: String = ""
        var timer: Timer?

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
                await chatService.queryChat(recipient: chatID)
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
            var text = draftMessage.text
            if !draftMessage.attachments.isEmpty {
                text = "photo"
            }
            let message = Chat.Message(
                id: UUID().uuidString,
                user: .init(id: "123", name: "Me", avatarURL: nil, isCurrentUser: true),
                text: text
            )
            
            Task {
                await chatService.sendMessage(message: message, recipient: chatID)
            }
        }

        func startTimer() {
            self.timer = Timer.scheduledTimer(
                timeInterval: 4,
                target: self,
                selector: #selector(updateChats),
                userInfo: nil,
                repeats: true
            )
        }

        func stopTimer() {
            self.timer?.invalidate()
        }

        @objc func updateChats() {
            Task {
                await chatService.updateMessageStatus(recipient: chatID)
            }
        }
     }
}
