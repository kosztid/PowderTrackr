import Combine
import ExyteChat
@testable import PowderTrackr
import XCTest

final class PowderTrackrChatViewModelTests: XCTestCase {
    private var viewModel: PowderTrackrChatView.ViewModel!
    private var chatServiceMock: ChatServiceProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = []
        chatServiceMock = ChatServiceProtocolMock()
        chatServiceMock.messagesPublisher = Just([Message(id: "msg1", user: ExyteChat.User(id: "1", name: "John", avatarURL: nil, isCurrentUser: true), text: "Hello")]).eraseToAnyPublisher()

        viewModel = PowderTrackrChatView.ViewModel(
            chatService: chatServiceMock,
            model: PowderTrackrChatView.InputModel(chatId: "chat1", names: ["John Doe"])
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
        chatServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    func test_initBindings_whenInitialized_shouldSubscribeToMessages() {
        XCTAssertEqual(viewModel.messages.count, 1, "Should initialize and load messages from the chat service.")
    }

    func test_sendMessage_whenCalled_shouldCreateAndSendMessage() {
        let draftMessage = DraftMessage(text: "Test message", medias: [], recording: nil, replyMessage: nil, createdAt: Date())
        viewModel.sendMessage(draftMessage: draftMessage)

        XCTAssertTrue(chatServiceMock.sendMessageMessageRecipientCalled, "sendMessage should be called on chatService.")
    }

    func test_updateChats_whenTimerFires_shouldRequestUpdate() {
        viewModel.startTimer()
        viewModel.updateChats()

        XCTAssertTrue(chatServiceMock.updateMessageStatusRecipientCalled, "updateMessageStatus should be called on chatService.")
        viewModel.stopTimer()
    }
}
