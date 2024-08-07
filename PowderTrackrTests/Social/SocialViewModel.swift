import Combine
@testable import PowderTrackr
import XCTest

final class SocialViewModelTests: XCTestCase {
    private var viewModel: SocialView.ViewModel!
    private var navigatorMock: SocialListViewNavigatorProtocolMock!
    private var friendService: FriendServiceProtocolMock!
    private var accountService: AccountServiceProtocolMock!
    private var chatService: ChatServiceProtocolMock!

    override func setUpWithError() throws {
        super.setUp()
        navigatorMock = SocialListViewNavigatorProtocolMock()
        friendService = FriendServiceProtocolMock()
        accountService = AccountServiceProtocolMock()
        chatService = ChatServiceProtocolMock()

        accountService.isSignedInPublisher = CurrentValueSubject<Bool, Never>(true).eraseToAnyPublisher()
        friendService.underlyingFriendListPublisher = CurrentValueSubject<Friendlist?, Never>(Friendlist(id: "123", friends: [Friend(id: "2", name: "Jane Doe", isTracking: true)])).eraseToAnyPublisher()
        friendService.underlyingFriendRequestsPublisher = CurrentValueSubject<[FriendRequest], Never>([]).eraseToAnyPublisher()
        chatService.underlyingChatNotificationPublisher = CurrentValueSubject<[String]?, Never>(["New Chat"]).eraseToAnyPublisher()
        chatService.underlyingLastMessagesPublisher = CurrentValueSubject<[SocialView.LastMessageModel]?, Never>([]).eraseToAnyPublisher()

        viewModel = SocialView.ViewModel(
            navigator: navigatorMock,
            friendService: friendService,
            accountService: accountService,
            chatService: chatService,
            inputModel: SocialView.InputModel(navigateToAccount: {})
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
        navigatorMock = nil
        friendService = nil
        accountService = nil
        chatService = nil
        super.tearDown()
    }

    func test_onAppear_whenViewAppears_shouldQueryServices() {
            viewModel.onAppear()

            XCTAssertTrue(friendService.queryFriendsCalled)
            XCTAssertTrue(friendService.queryFriendRequestsCalled)
            XCTAssertTrue(chatService.getChatNotificationsCalled)
        }

        func test_navigateToAddFriend_whenCalled_shouldNavigateToAddWithUsers() {
            let expect = expectation(description: "Navigate to add friend with users")

            friendService.getAddableUsersReturnValue = Future<[User], Error> { promise in
                    promise(.success([]))
            }

            viewModel.navigateToAddFriend()

            expect.fulfill()

            waitForExpectations(timeout: 1.0)
        }

        func test_navigateToRequests_whenCalled_shouldNavigateToRequests() {
            viewModel.navigateToRequests()

            XCTAssertTrue(navigatorMock.navigateToRequestCalled)
        }

        func test_removeFriend_whenCalled_shouldRemoveFriendFromList() {
            let friend = Friend(id: "2", name: "Jane Doe", isTracking: true)
            viewModel.friendList = Friendlist(id: "123", friends: [friend])

            viewModel.removeFriend(friend: friend)

            XCTAssertTrue(friendService.deleteFriendFriendCalled)
            XCTAssertTrue(viewModel.friendList?.friends?.isEmpty ?? false)
        }

        func test_updateTracking_whenCalled_shouldUpdateTrackingStatus() {
            let friendId = "3"
            viewModel.updateTracking(id: friendId)

            XCTAssertTrue(friendService.updateTrackingIdCalled)
        }

        func test_navigateToChatWithFriend_whenCalled_shouldNavigateToChat() {
            let friendId = "4"
            let friendName = "Emily"
            viewModel.navigateToChatWithFriend(friendId: friendId, friendName: friendName)

            XCTAssertTrue(navigatorMock.navigateToChatModelCalled)
        }

        func test_lastMessage_forId_shouldReturnMessage() {
            let message = Message(id: "1", sender: "John", date: "2000.01.01.", text: "Hello", isPhoto: false, isSeen: false)
            let lastMessageModel = SocialView.LastMessageModel(id: "1", message: message)
            viewModel.lastMessages = [lastMessageModel]

            let result = viewModel.lastMessage(for: "1")

            XCTAssertEqual(result?.text, message.text)
        }

        func test_notification_forFriendId_shouldReturnNotificationStatus() {
            let friendId = "1"
            viewModel.chatNotifications = [friendId]

            XCTAssertTrue(viewModel.notification(for: friendId))
        }
}
