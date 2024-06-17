import ExyteChat
import Combine
import SwiftUI

public extension PowderTrackrChatView {
    struct InputModel {
        let chatId: String
        let names: [String]
    }
    final class ViewModel: ObservableObject {
        @Published var messages: [ExyteChat.Message] = []
        @Published var chat: String = ""
        
        let model: InputModel
        let names: [String]
        var timer: Timer?

        private let chatService: ChatServiceProtocol
        private let chatID: String

        private var cancellables: Set<AnyCancellable> = []

        init(
            chatService: ChatServiceProtocol,
            model: InputModel
        ) {
            self.chatService = chatService
            self.chatID = model.chatId
            self.names = model.names
            self.model = model
            initBindings()
            chatService.queryChat(recipient: chatID)
        }

        func initBindings() {
            chatService.messagesPublisher
                .sink { _ in
                } receiveValue: { [weak self] messages in
                    self?.messages = messages ?? []
                }
                .store(in: &cancellables)
        }

        func sendMessage(draftMessage: ExyteChat.DraftMessage) {
            let message = ExyteChat.Message(
                id: UUID().uuidString,
                user: .init(id: "123", name: Str.Sender.outgoing, avatarURL: nil, isCurrentUser: true),
                text: draftMessage.text
            )
            chatService.sendMessage(message: message, recipient: chatID)
        }

        func startTimer() {
            self.timer = Timer.scheduledTimer(
                timeInterval: 2,
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
            chatService.updateMessageStatus(recipient: chatID)
        }
     }
}
