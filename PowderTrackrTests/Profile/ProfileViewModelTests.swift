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
        XCTAssertNotNil(viewModel, "ViewModel should not be nil after initialization")
        XCTAssertTrue(viewModel.isSignedIn, "ViewModel should reflect signed-in status from the account service")
    }

    func test_login_whenInvoked_triggersNavigationToLogin() {
        viewModel.login()

        XCTAssertTrue(navigatorMock.loginCalled, "login should trigger navigation to login screen")
    }

    func test_register_whenInvoked_triggersNavigationToRegister() {
        viewModel.register()

        XCTAssertTrue(navigatorMock.registerCalled, "register should trigger navigation to registration screen")
    }

    func test_updatePasswordTap_whenInvoked_triggersPasswordUpdateNavigation() {
        viewModel.updatePasswordTap()

        XCTAssertTrue(navigatorMock.updatePasswordCalled, "updatePassword should trigger navigation to update password screen")
    }

    func test_dismissButtonTap_whenInvoked_triggersDismissScreen() {
        viewModel.dismissButtonTap()

        XCTAssertTrue(navigatorMock.dismissScreenCalled, "dismissButtonTap should trigger navigation to dismiss the screen")
    }

    func test_makeTotals_whenCalled_updatesTotals() {
        viewModel.makeTotals()

        XCTAssertGreaterThan(viewModel.totalDistance, 0, "Total distance should be updated and greater than zero after totals are made")
        XCTAssertNotEqual(viewModel.totalTime, "", "Total time should be updated and not be empty after totals are made")
    }
}
