import Combine
@testable import PowderTrackr
import XCTest

final class FriendAddViewModelTests: XCTestCase {
    private var viewModel: FriendAddView.ViewModel!
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

        viewModel = FriendAddView.ViewModel(
            navigator: navigatorMock,
            service: serviceMock,
            model: inputModel
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
        navigatorMock = nil
        serviceMock = nil
        inputModel = nil
        super.tearDown()
    }

    func test_initialState_whenInitialized_shouldContainAllUsers() {
        XCTAssertEqual(viewModel.users.count, 2, "Should load all users from the input model.")
    }

    func test_filteredUsers_whenSearchTextIsNotEmpty_shouldFilterUsers() {
        viewModel.searchText = "John"
        let filteredUsers = viewModel.filteredUsers

        XCTAssertEqual(filteredUsers.count, 1, "Should filter users based on search text.")
        XCTAssertEqual(filteredUsers.first?.name, "John Doe", "Filtered user should be John Doe.")
    }

    func test_addFriend_whenCalled_shouldSendFriendRequestAndRemoveUser() {
        let expect = expectation(description: "Friend request sent")
        let userToAdd = User(id: "1", name: "John Doe", email: "john@example.com")

        serviceMock.sendFriendRequestRecipientReturnValue = Future<Void, Error> { promise in
            promise(.success(()))
        }

        viewModel.addFriend(user: userToAdd)

        DispatchQueue.main.async { [weak self] in
            XCTAssertTrue(self?.viewModel.users.allSatisfy { $0.id != userToAdd.id } ?? false, "User should be removed after adding as friend.")
            XCTAssertNotNil(self?.viewModel.toast, "Toast should be presented on successful friend request.")
            XCTAssertEqual(self?.viewModel.toast?.title, "Friendrequest sent to John Doe", "Toast message should confirm friend request.")
            expect.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func test_dismissButtonTap_whenCalled_shouldNavigateBack() {
        viewModel.dismissButtonTap()

        XCTAssertTrue(navigatorMock.navigateBackCalled, "Should navigate back upon dismiss button tap.")
    }
}
