import Combine
@testable import PowderTrackr
import XCTest

final class ProfileViewModelTests: XCTestCase {
    private var viewModel: ProfileView.ViewModel!
    private var navigatorMock: ProfileViewNavigatorProtocolMock!
    private var accountServiceMock: AccountServiceProtocolMock!
    private var mapServiceMock: MapServiceProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        navigatorMock = ProfileViewNavigatorProtocolMock()
        accountServiceMock = AccountServiceProtocolMock()
        mapServiceMock = MapServiceProtocolMock()

        accountServiceMock.isSignedInPublisher = Just(true).eraseToAnyPublisher()
        let trackedPath = TrackedPath(id: "1", name: "Path 1", startDate: "2023-01-01 10:00:00", endDate: "2023-01-01 11:00:00", xCoords: [0.0, 1.0], yCoords: [0.0, 1.0], tracking: true)
        let trackedPathsModel = TrackedPathModel(id: "1", tracks: [trackedPath])
        mapServiceMock.trackedPathPublisher = Just(trackedPathsModel).eraseToAnyPublisher()

        viewModel = ProfileView.ViewModel(
            navigator: navigatorMock,
            accountService: accountServiceMock,
            mapService: mapServiceMock
        )
    }

    override func tearDownWithError() throws {
        viewModel = nil
        navigatorMock = nil
        accountServiceMock = nil
        mapServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    func test_viewModelInitialization_whenCreated_bindsToServices() {
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.isSignedIn)
    }

    func test_login_whenInvoked_triggersNavigationToLogin() {
        viewModel.login()

        XCTAssertTrue(navigatorMock.loginCalled)
    }

    func test_register_whenInvoked_triggersNavigationToRegister() {
        viewModel.register()

        XCTAssertTrue(navigatorMock.registerCalled)
    }

    func test_updatePasswordTap_whenInvoked_triggersPasswordUpdateNavigation() {
        viewModel.updatePasswordTap()

        XCTAssertTrue(navigatorMock.updatePasswordCalled)
    }

    func test_dismissButtonTap_whenInvoked_triggersDismissScreen() {
        viewModel.dismissButtonTap()

        XCTAssertTrue(navigatorMock.dismissScreenCalled)
    }

    func test_makeTotals_whenCalled_updatesTotals() {
        viewModel.makeTotals()

        XCTAssertGreaterThan(viewModel.totalDistance, .zero)
        XCTAssertNotEqual(viewModel.totalTime, "")
    }
}
