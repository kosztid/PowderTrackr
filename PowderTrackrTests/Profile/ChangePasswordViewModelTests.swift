import Combine
@testable import PowderTrackr
import XCTest

final class ChangePasswordViewModelTests: XCTestCase {
    private var sut: ChangePasswordView.ViewModel!
    private var navigatorMock: ChangePasswordViewNavigatorProtocolMock!
    private var accountServiceMock: AccountServiceProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        navigatorMock = ChangePasswordViewNavigatorProtocolMock()
        accountServiceMock = AccountServiceProtocolMock()

        sut = ChangePasswordView.ViewModel(
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

    func test_changeButtonTap_whenPasswordChangeSucceeds_shouldShowSuccessToastAndNavigate() {
        accountServiceMock.changePasswordOldPasswordNewPasswordReturnValue = Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Show success toast and navigate after password change")

        sut.$toast
            .dropFirst()
            .sink { toast in
                XCTAssertNotNil(toast)
                XCTAssertEqual(toast?.title, "Password changed successfully")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.changeButtonTap()

        wait(for: [expectation], timeout: 1.0)
    }

    func test_changeButtonTap_whenPasswordChangeFails_shouldShowErrorToast() {
        accountServiceMock.changePasswordOldPasswordNewPasswordReturnValue = Fail<Void, Error>(error: NSError(domain: "ChangePasswordError", code: -1, userInfo: nil))
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Show error toast when password change fails")

        sut.$toast
            .dropFirst()
            .sink { toast in
                XCTAssertNotNil(toast)
                XCTAssertEqual(toast?.title, "Failed changing password")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.changeButtonTap()

        wait(for: [expectation], timeout: 1.0)
    }

    func test_navigateBack_whenInvoked_shouldCallNavigateBackOnNavigator() {
        sut.navigateBack()

        XCTAssertTrue(navigatorMock.navigateBackCalled)
    }
}
