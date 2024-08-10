import Combine
@testable import PowderTrackr
import XCTest

final class TrackListViewModelTests: XCTestCase {
    private var viewModel: TrackListView.ViewModel!
    private var mapService: MapServiceProtocolMock!
    private var accountService: AccountServiceProtocolMock!
    private var friendService: FriendServiceProtocolMock!
    private var paths: TrackedPathModel = .init(id: "123", tracks: [])

    override func setUpWithError() throws {
        super.setUp()
        mapService = MapServiceProtocolMock()
        accountService = AccountServiceProtocolMock()
        friendService = FriendServiceProtocolMock()

        mapService.underlyingTrackedPathPublisher = CurrentValueSubject<TrackedPathModel?, Never>(paths).eraseToAnyPublisher()
        mapService.underlyingSharedPathPublisher = CurrentValueSubject<TrackedPathModel?, Never>(paths).eraseToAnyPublisher()
        mapService.networkErrorPublisher = CurrentValueSubject<ToastModel?, Never>(nil).eraseToAnyPublisher()
        friendService.underlyingFriendListPublisher = CurrentValueSubject<Friendlist?, Never>(nil).eraseToAnyPublisher()
        accountService.isSignedInPublisher = CurrentValueSubject<Bool, Never>(true).eraseToAnyPublisher()

        let inputModel = TrackListView.InputModel(navigateToAccount: {})
        viewModel = TrackListView.ViewModel(
            mapService: mapService,
            accountService: accountService,
            friendService: friendService,
            inputModel: inputModel
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mapService = nil
        accountService = nil
        friendService = nil
        super.tearDown()
    }

    func test_onAppear_whenCalled_shouldQueryTrackedAndSharedPaths() {
        viewModel.onAppear()

        XCTAssertTrue(mapService.queryTrackedPathsCalled)
        XCTAssertTrue(mapService.querySharedPathsCalled)
    }

    func test_calculateDistance_whenPathSelected_shouldReturnCorrectDistance() {
        let track = TrackedPath(id: "testTrack", name: "testTrack", startDate: "", endDate: "", xCoords: [0.0, 1.0], yCoords: [0.0, 1.0], tracking: false)
        let distance = viewModel.calculateDistance(track: track)

        XCTAssertEqual(distance, 157_249.37625418047, accuracy: 1_000)
    }

    func test_removeTrack_whenCalled_shouldRemoveTrackFromService() {
        let track = TrackedPath(id: "testTrack", name: "testTrack", startDate: "", endDate: "", xCoords: [0.0, 1.0], yCoords: [0.0, 1.0], tracking: false)
        viewModel.removeTrack(track)

        XCTAssertTrue(mapService.removeTrackedPathCalled)
    }

    func test_updateTrack_whenCalled_shouldUpdateTrackInService() {
        let track = TrackedPath(id: "testTrack", name: "testTrack", startDate: "", endDate: "", xCoords: [0.0, 1.0], yCoords: [0.0, 1.0], tracking: false)
        viewModel.updateTrack(track, shared: false)

        XCTAssertTrue(mapService.updateTrackCalled)
    }

    func test_shareTrack_whenCalled_shouldSetTrackToShare() {
        let track = TrackedPath(id: "testTrack", name: "testTrack", startDate: "", endDate: "", xCoords: [0.0, 1.0], yCoords: [0.0, 1.0], tracking: false)
        viewModel.shareTrack(track)

        XCTAssertNotNil(viewModel.trackToShare)
        XCTAssertEqual(viewModel.trackToShare?.id, track.id)
    }

    func test_addNote_whenCalled_shouldAppendNoteAndUpdateTrack() {
        var track = TrackedPath(id: "testTrack", name: "testTrack", startDate: "", endDate: "", xCoords: [0.0, 1.0], yCoords: [0.0, 1.0], tracking: false)
        track.notes = []
        viewModel.addNote("New Note", track)

        XCTAssertTrue(mapService.updateTrackCalled)
        XCTAssertEqual(mapService.updateTrackCallsCount, 1)
    }

    func test_share_whenTrackToShareExists_shouldShareTrack() {
        let track = TrackedPath(id: "testTrack", name: "testTrack", startDate: "", endDate: "", xCoords: [0.0, 1.0], yCoords: [0.0, 1.0], tracking: false)
        viewModel.trackToShare = track
        let friend = Friend(id: "friend1", name: "Friend One", isTracking: true)

        viewModel.share(with: friend)

        XCTAssertTrue(mapService.shareTrackCalled)
        XCTAssertEqual(mapService.shareTrackCallsCount, 1)
    }

    func test_removeSharedTrack_whenCalled_shouldRemoveSharedTrackFromService() {
        let track = TrackedPath(id: "testTrack", name: "testTrack", startDate: "", endDate: "", xCoords: [0.0, 1.0], yCoords: [0.0, 1.0], tracking: false)
        viewModel.removeSharedTrack(track)

        XCTAssertTrue(mapService.removeSharedTrackedPathCalled)
        XCTAssertEqual(mapService.removeSharedTrackedPathCallsCount, 1)
    }
}
