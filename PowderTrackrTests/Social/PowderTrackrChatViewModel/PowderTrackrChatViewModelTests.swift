import Combine
import ExyteChat
@testable import PowderTrackr
import XCTest

final class PowderTrackrChatViewModelTests: XCTestCase {
    private var sut: PowderTrackrChatView.ViewModel!
    private var chatServiceMock: ChatServiceProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = []
        chatServiceMock = ChatServiceProtocolMock()
        chatServiceMock.messagesPublisher = Just([Message(id: "msg1", user: ExyteChat.User(id: "1", name: "John", avatarURL: nil, isCurrentUser: true), text: "Hello")]).eraseToAnyPublisher()

        sut = PowderTrackrChatView.ViewModel(
            chatService: chatServiceMock,
            model: PowderTrackrChatView.InputModel(chatId: "chat1", names: ["John Doe"])
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        chatServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    func test_initBindings_whenInitialized_shouldSubscribeToMessages() {
        XCTAssertEqual(sut.messages.count, 1, "Should initialize and load messages from the chat service.")
    }

    func test_sendMessage_whenCalled_shouldCreateAndSendMessage() {
        let draftMessage = DraftMessage(text: "Test message", medias: [], recording: nil, replyMessage: nil, createdAt: Date())
        sut.sendMessage(draftMessage: draftMessage)

        XCTAssertTrue(chatServiceMock.sendMessageMessageRecipientCalled, "sendMessage should be called on chatService.")
    }

    func test_updateChats_whenTimerFires_shouldRequestUpdate() {
        sut.startTimer()
        sut.updateChats()

        XCTAssertTrue(chatServiceMock.updateMessageStatusRecipientCalled, "updateMessageStatus should be called on chatService.")
        sut.stopTimer()
    }
}
