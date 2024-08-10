import Combine
@testable import PowderTrackr
import XCTest

final class FriendAddViewModelTests: XCTestCase {
    private var sut: FriendAddView.ViewModel!
    private var navigatorMock: SocialAddViewNavigatorProtocolMock!
    private var serviceMock: FriendServiceProtocolMock!
    private var inputModel: FriendAddView.InputModel!

    override func setUpWithError() throws {
        super.setUp()

        navigatorMock = SocialAddViewNavigatorProtocolMock()
        serviceMock = FriendServiceProtocolMock()

        inputModel = FriendAddView.InputModel(users: [
            User(id: "1", name: "John Doe", email: "john@example.com"),
            User(id: "2", name: "Jane Smith", email: "jane@example.com")
        ])

        sut = FriendAddView.ViewModel(
            navigator: navigatorMock,
            service: serviceMock,
            model: inputModel
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        navigatorMock = nil
        serviceMock = nil
        inputModel = nil
        super.tearDown()
    }

    func test_initialState_whenInitialized_shouldContainAllUsers() {
        XCTAssertEqual(sut.users.count, 2)
    }

    func test_filteredUsers_whenSearchTextIsNotEmpty_shouldFilterUsers() {
        sut.searchText = "John"
        let filteredUsers = sut.filteredUsers

        XCTAssertEqual(filteredUsers.count, 1)
        XCTAssertEqual(filteredUsers.first?.name, "John Doe")
    }

    func test_addFriend_whenCalled_shouldSendFriendRequestAndRemoveUser() {
        let expect = expectation(description: "Friend request sent")
        let userToAdd = User(id: "1", name: "John Doe", email: "john@example.com")

        serviceMock.sendFriendRequestRecipientReturnValue = Future<Void, Error> { promise in
            promise(.success(()))
        }

        sut.addFriend(user: userToAdd)

        DispatchQueue.main.async { [weak self] in
            XCTAssertTrue(self?.sut.users.allSatisfy { $0.id != userToAdd.id } ?? false)
            XCTAssertNotNil(self?.sut.toast)
            XCTAssertEqual(self?.sut.toast?.title, "Friendrequest sent to John Doe")
            expect.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func test_dismissButtonTap_whenCalled_shouldNavigateBack() {
        sut.dismissButtonTap()

        XCTAssertTrue(navigatorMock.navigateBackCalled)
    }
}
