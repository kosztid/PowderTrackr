import Combine
@testable import PowderTrackr
import XCTest

final class ResetPasswordViewModelTests: XCTestCase {
    private var sut: ResetPasswordView.ViewModel!
    private var navigatorMock: ResetPasswordViewNavigatorProtocolMock!
    private var accountServiceMock: AccountServiceProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        navigatorMock = ResetPasswordViewNavigatorProtocolMock()
        accountServiceMock = AccountServiceProtocolMock()

        sut = ResetPasswordView.ViewModel(
            navigator: navigatorMock,
            accountService: accountServiceMock
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        navigatorMock = nil
        accountServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    func test_reset_whenResetSucceeds_shouldShowSuccessToastAndNavigate() {
        accountServiceMock.resetPasswordUsernameReturnValue = Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        sut.reset()

        XCTAssertNotNil(sut.toast)
    }

    func test_reset_whenResetFails_shouldShowErrorToast() {
        accountServiceMock.resetPasswordUsernameReturnValue = Fail<Void, Error>(error: NSError(domain: "ResetPasswordError", code: -1, userInfo: nil))
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Show error toast")

        sut.$toast
            .dropFirst()
            .sink { toast in
                XCTAssertNotNil(toast)
                XCTAssertEqual(toast?.title)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.reset()

        wait(for: [expectation], timeout: 1.0)
    }

    func test_navigateBack_whenInvoked_shouldCallNavigateBackOnNavigator() {
        sut.navigateBack()

        XCTAssertTrue(navigatorMock.navigateBackCalled)
    }
}
