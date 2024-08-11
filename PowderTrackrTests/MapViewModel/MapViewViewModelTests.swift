import Combine
@testable import PowderTrackr
import XCTest

class MapViewViewModelTests: XCTestCase {
    private var viewModel: MapView.ViewModel!
    private var accountService: AccountServiceProtocolMock!
    private var friendService: FriendServiceProtocolMock!
    private var mapService: MapServiceProtocolMock!

    private var paths: TrackedPathModel = .init(id: "123", tracks: [])

    override func setUp() {
        super.setUp()
        accountService = AccountServiceProtocolMock()
        friendService = FriendServiceProtocolMock()
        mapService = MapServiceProtocolMock()
        mapService.underlyingTrackedPathPublisher = CurrentValueSubject<TrackedPathModel?, Never>(paths).eraseToAnyPublisher()
        mapService.raceCreationStatePublisher = CurrentValueSubject<RaceCreationState, Never>(.not).eraseToAnyPublisher()
        mapService.networkErrorPublisher = CurrentValueSubject<ToastModel?, Never>(nil).eraseToAnyPublisher()
        accountService.isSignedInPublisher = CurrentValueSubject<Bool, Never>(true).eraseToAnyPublisher()

        viewModel = MapView.ViewModel(
            accountService: accountService,
            mapService: mapService,
            friendService: friendService
        )
    }

    override func tearDown() {
        viewModel = nil
        accountService = nil
        friendService = nil
        mapService = nil
        super.tearDown()
    }

    func test_raceTrackAction_whenCalled_shouldStartRaceTrackingAndInitializeTimers() {
        XCTAssertFalse(viewModel.raceTracking)

        viewModel.raceTrackAction()

        XCTAssertTrue(viewModel.raceTracking)
        XCTAssertTrue(viewModel.isTracking)
        XCTAssertNotNil(viewModel.trackTimer)
        XCTAssertNotNil(viewModel.widgetTimer)
        XCTAssertNotNil(viewModel.watchTimer)
    }

    func test_startTracking_whenCalled_shouldSetIsTrackingToTrueAndStartTimers() {
        XCTAssertFalse(viewModel.isTracking)

        viewModel.startTracking()

        XCTAssertTrue(viewModel.isTracking)
        XCTAssertNotNil(viewModel.trackTimer)
        XCTAssertNotNil(viewModel.widgetTimer)
        XCTAssertNotNil(viewModel.watchTimer)
        XCTAssertTrue(viewModel.isTrackingStorage)
    }

    func test_stopTracking_whenCalled_shouldSetIsTrackingToFalseAndInvalidateTimers() {
        viewModel.startTracking()
        XCTAssertNotNil(viewModel.trackTimer)

        viewModel.stopTracking()

        XCTAssertFalse(viewModel.isTracking)
        XCTAssertNil(viewModel.trackTimer)
        XCTAssertNil(viewModel.widgetTimer)
        XCTAssertNil(viewModel.watchTimer)
        XCTAssertFalse(viewModel.isTrackingStorage)
    }

    func test_updateLocation_whenCalled_shouldUpdateLocationAndQueryFriendLocations() {
        viewModel.updateLocation()

        XCTAssertTrue(accountService.updateLocationXCoordYCoordCalled)
        XCTAssertTrue(friendService.queryFriendLocationsCalled)
    }

    func test_calculateDistance_whenPathSelected_shouldReturnCorrectDistance() {
        let path = TrackedPath(id: "123", name: "123", startDate: "123", endDate: "123", xCoords: [], yCoords: [], tracking: false)
        viewModel.selectedPath = path

        let distance = viewModel.calculateDistance()

        XCTAssertEqual(distance, 0)
    }

    func test_resumeTracking_whenCalled_shouldResumeTrackingAndSetMapMenuStateToOn() {
        viewModel.resumeTracking()

        XCTAssertNotNil(viewModel.trackTimer)
        XCTAssertEqual(viewModel.mapMenuState, .on)
    }

    func test_pauseTracking_whenCalled_shouldPauseTrackingAndSetMapMenuStateToPaused() {
        viewModel.startTracking()
        viewModel.pauseTracking()

        XCTAssertNil(viewModel.trackTimer)
        XCTAssertEqual(viewModel.mapMenuState, .paused)
    }

    func test_updateWidget_whenCalled_shouldUpdateWidgetInformation() {
        viewModel.startTracking()
        viewModel.updateWidget()

        XCTAssertNotNil(viewModel.elapsedTimeStorage)
        XCTAssertNotNil(viewModel.avgSpeedStorage)
        XCTAssertNotNil(viewModel.distanceStorage)
    }

    func test_refreshSelectedPath_whenPathExists_shouldRefreshSelectedPath() {
        let path = TrackedPath(id: "test", name: "123", startDate: "123", endDate: "123", xCoords: [], yCoords: [], tracking: false)
        viewModel.track.append(path)
        viewModel.selectedPath = path

        viewModel.refreshSelectedPath()

        XCTAssertNotNil(viewModel.selectedPath)
        XCTAssertEqual(viewModel.selectedPath?.id, "test")
    }
}
