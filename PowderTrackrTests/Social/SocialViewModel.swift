import Combine
@testable import PowderTrackr
import XCTest

final class SocialViewModelTests: XCTestCase {
    private var sut: SocialView.ViewModel!
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

        sut = SocialView.ViewModel(
            navigator: navigatorMock,
            friendService: friendService,
            accountService: accountService,
            chatService: chatService,
            inputModel: SocialView.InputModel(navigateToAccount: {})
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        navigatorMock = nil
        friendService = nil
        accountService = nil
        chatService = nil
        super.tearDown()
    }

    func test_onAppear_whenViewAppears_shouldQueryServices() {
        sut.onAppear()

            XCTAssertTrue(friendService.queryFriendsCalled)
            XCTAssertTrue(friendService.queryFriendRequestsCalled)
            XCTAssertTrue(chatService.getChatNotificationsCalled)
        }

        func test_navigateToAddFriend_whenCalled_shouldNavigateToAddWithUsers() {
            let expect = expectation(description: "Navigate to add friend with users")

            friendService.getAddableUsersReturnValue = Future<[User], Error> { promise in
                    promise(.success([]))
            }

            sut.navigateToAddFriend()

            expect.fulfill()

            waitForExpectations(timeout: 1.0)
        }

        func test_navigateToRequests_whenCalled_shouldNavigateToRequests() {
            sut.navigateToRequests()

            XCTAssertTrue(navigatorMock.navigateToRequestCalled)
        }

        func test_removeFriend_whenCalled_shouldRemoveFriendFromList() {
            let friend = Friend(id: "2", name: "Jane Doe", isTracking: true)
            sut.friendList = Friendlist(id: "123", friends: [friend])

            sut.removeFriend(friend: friend)

            XCTAssertTrue(friendService.deleteFriendFriendCalled)
            XCTAssertTrue(sut.friendList?.friends?.isEmpty ?? false)
        }

        func test_updateTracking_whenCalled_shouldUpdateTrackingStatus() {
            let friendId = "3"
            sut.updateTracking(id: friendId)

            XCTAssertTrue(friendService.updateTrackingIdCalled)
        }

        func test_navigateToChatWithFriend_whenCalled_shouldNavigateToChat() {
            let friendId = "4"
            let friendName = "Emily"
            sut.navigateToChatWithFriend(friendId: friendId, friendName: friendName)

            XCTAssertTrue(navigatorMock.navigateToChatModelCalled)
        }

        func test_lastMessage_forId_shouldReturnMessage() {
            let message = Message(id: "1", sender: "John", date: "2000.01.01.", text: "Hello", isPhoto: false, isSeen: false)
            let lastMessageModel = SocialView.LastMessageModel(id: "1", message: message)
            sut.lastMessages = [lastMessageModel]

            let result = sut.lastMessage(for: "1")

            XCTAssertEqual(result?.text, message.text)
        }

        func test_notification_forFriendId_shouldReturnNotificationStatus() {
            let friendId = "1"
            sut.chatNotifications = [friendId]

            XCTAssertTrue(sut.notification(for: friendId))
        }
}
