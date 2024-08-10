import Combine
@testable import PowderTrackr
import XCTest

final class ConfirmResetPasswordViewModelTests: XCTestCase {
    private var sut: ConfirmResetPasswordView.ViewModel!
    private var navigatorMock: RegisterVerificationViewNavigatorProtocolMock!
    private var accountServiceMock: AccountServiceProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        navigatorMock = RegisterVerificationViewNavigatorProtocolMock()
        accountServiceMock = AccountServiceProtocolMock()

        sut = ConfirmResetPasswordView.ViewModel(
            navigator: navigatorMock,
            accountService: accountServiceMock,
            username: "testuser"
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        navigatorMock = nil
        accountServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    func test_verify_whenConfirmationSucceeds_shouldNavigateToVerified() {
        accountServiceMock.confirmResetPasswordUsernameNewPasswordConfirmationCodeReturnValue = Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        sut.verify()

        XCTAssertTrue(navigatorMock.verifiedCalled)
    }

    func test_verify_whenConfirmationFails_shouldShowErrorToast() {
        let expectation = XCTestExpectation(description: "Show error toast")
        accountServiceMock.confirmResetPasswordUsernameNewPasswordConfirmationCodeReturnValue = Fail<Void, Error>(error: NSError(domain: "ResetPasswordError", code: -1, userInfo: nil))
            .eraseToAnyPublisher()

        sut.verify()

        sut.$toast
            .sink { toast in
                XCTAssertNotNil(toast)
                XCTAssertEqual(toast?.title, "Failed resetting password")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
