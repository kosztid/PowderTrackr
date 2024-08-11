import Combine
@testable import PowderTrackr
import XCTest

final class FriendRequestViewModelTests: XCTestCase {
    private var sut: FriendRequestView.ViewModel!
    private var service: FriendServiceProtocolMock!
    private var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        super.setUp()

        service = FriendServiceProtocolMock()

        service.underlyingFriendRequestsPublisher = CurrentValueSubject<[FriendRequest], Never>([
            FriendRequest(id: "1", senderEmail: "john@test.com", sender: .init(id: "1", name: "John", isTracking: false), recipient: "Jane"),
            FriendRequest(id: "2", senderEmail: "", sender: .init(id: "", name: "Jane", isTracking: false), recipient: "John")
        ]).eraseToAnyPublisher()

        sut = FriendRequestView.ViewModel(service: service)
    }

    override func tearDownWithError() throws {
        sut = nil
        service = nil
        super.tearDown()
    }

    func test_initFriendRequests_whenViewModelInitialized_shouldBindAndLoadRequests() {
        XCTAssertEqual(sut.friendRequests.count, 2)
    }

    func test_acceptRequest_whenCalled_shouldRemoveRequestAndUpdateService() {
        let request = FriendRequest(id: "1", senderEmail: "john@test.com", sender: .init(id: "1", name: "John", isTracking: false), recipient: "Jane")

        sut.acceptRequest(request)

        XCTAssertTrue(service.addFriendRequestCalled)
        XCTAssertEqual(sut.friendRequests.count, 1)
        XCTAssertFalse(sut.friendRequests.contains(where: { $0.id == "1" }))
    }

    func test_refreshRequests_whenCalled_shouldQueryService() {
        sut.refreshRequests()

        XCTAssertTrue(service.queryFriendRequestsCalled)
    }
}
