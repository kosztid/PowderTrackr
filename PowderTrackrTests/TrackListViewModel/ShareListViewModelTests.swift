import Combine
@testable import PowderTrackr
import XCTest

final class ShareListViewModelTests: XCTestCase {
    private var viewModel: ShareListView.ViewModel!
    private var mapService: MapServiceProtocolMock!
    private var friendService: FriendServiceProtocolMock!
    private var track: TrackedPath!

    override func setUpWithError() throws {
        super.setUp()
        mapService = MapServiceProtocolMock()
        friendService = FriendServiceProtocolMock()
        track = TrackedPath(id: "testTrack", name: "testTrack", startDate: "", endDate: "", xCoords: [0.0, 1.0], yCoords: [0.0, 1.0], tracking: false)

        let friendList = Friendlist(id: "123", friends: [Friend(id: "1", name: "John Doe", isTracking: true)])
        friendService.underlyingFriendListPublisher = CurrentValueSubject<Friendlist?, Never>(friendList).eraseToAnyPublisher()

        viewModel = ShareListView.ViewModel(
            friendService: friendService,
            mapService: mapService,
            track: track
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mapService = nil
        friendService = nil
        track = nil
        super.tearDown()
    }

    func test_initBindings_whenViewModelInitialized_shouldSubscribeToFriendListPublisher() {
        XCTAssertEqual(viewModel.friendList?.friends?.count, 1)
        XCTAssertEqual(viewModel.friendList?.friends?.first?.name, "John Doe")
    }

    func test_share_shouldCallShareTrackOnMapService() {
        let friend = Friend(id: "friend1", name: "Friend One", isTracking: true)

        viewModel.share(with: friend)

        XCTAssertTrue(mapService.shareTrackCalled)
        XCTAssertEqual(mapService.shareTrackCallsCount, 1)
    }
}
