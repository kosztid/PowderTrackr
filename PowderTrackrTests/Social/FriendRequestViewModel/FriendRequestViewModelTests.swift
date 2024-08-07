import Combine
@testable import PowderTrackr
import XCTest

final class FriendRequestViewModelTests: XCTestCase {
    private var viewModel: FriendRequestView.ViewModel!
    private var service: FriendServiceProtocolMock!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        super.setUp()

        service = FriendServiceProtocolMock()

        service.underlyingFriendRequestsPublisher = CurrentValueSubject<[FriendRequest], Never>([
            FriendRequest(id: "1", senderEmail: "john@test.com", sender: .init(id: "1", name: "John", isTracking: false), recipient: "Jane"),
            FriendRequest(id: "2", senderEmail: "", sender: .init(id: "", name: "Jane", isTracking: false), recipient: "John")
        ]).eraseToAnyPublisher()

        viewModel = FriendRequestView.ViewModel(service: service)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        service = nil
        super.tearDown()
    }

    func test_initFriendRequests_whenViewModelInitialized_shouldBindAndLoadRequests() {
        XCTAssertEqual(viewModel.friendRequests.count, 2, "Should load initial friend requests.")
    }

    func test_acceptRequest_whenCalled_shouldRemoveRequestAndUpdateService() {
        let request = FriendRequest(id: "1", senderEmail: "john@test.com", sender: .init(id: "1", name: "John", isTracking: false), recipient: "Jane")

        viewModel.acceptRequest(request)

        XCTAssertTrue(service.addFriendRequestCalled, "Service method to add friend should be called.")
        XCTAssertEqual(viewModel.friendRequests.count, 1, "Should remove the accepted request from the list.")
        XCTAssertFalse(viewModel.friendRequests.contains(where: { $0.id == "1" }), "The accepted request should no longer be present.")
    }

    func test_refreshRequests_whenCalled_shouldQueryService() {
        viewModel.refreshRequests()

        XCTAssertTrue(service.queryFriendRequestsCalled, "Service method to query friend requests should be called.")
    }
}
