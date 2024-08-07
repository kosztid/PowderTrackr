import Combine
@testable import PowderTrackr
import XCTest

class LoginViewModelTests: XCTestCase {
    private var sut: LoginView.ViewModel!
    private var navigatorMock: LoginViewNavigatorProtocolMock!
    private var accountServiceMock: AccountServiceProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        navigatorMock = LoginViewNavigatorProtocolMock()
        accountServiceMock = AccountServiceProtocolMock()

        accountServiceMock.isSignedInPublisher = CurrentValueSubject<Bool, Never>(false).eraseToAnyPublisher()

        sut = LoginView.ViewModel(navigator: navigatorMock, accountService: accountServiceMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        navigatorMock = nil
        accountServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    func test_login_whenCredentialsAreValid_shouldNavigateToLoggedIn() {
        accountServiceMock.signInFirstTimeReturnValue = Just(AccountServiceModel.AccountData(userID: "123")).setFailureType(to: Error.self).eraseToAnyPublisher()

        sut.login()

        XCTAssertTrue(navigatorMock.loggedInCalled)
    }

    func test_login_whenCredentialsAreInvalid_shouldShowLoginError() {
        let failureCompletionExpectation = expectation(description: "Login failure should be called")
        accountServiceMock.signInFirstTimeReturnValue = Fail<AccountServiceModel.AccountData, Error>(error: NSError(domain: "LoginError", code: -1, userInfo: nil)).eraseToAnyPublisher()

        sut.login()

        sut.$showLoginError
            .sink { showLoginError in
                XCTAssertTrue(showLoginError, "showLoginError should be true when login fails")
                failureCompletionExpectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_resetPassword_shouldNavigateToResetPassword() {
        sut.resetPassword()

        XCTAssertTrue(navigatorMock.navigateToResetPasswordCalled, "navigateToResetPassword should be called on navigator")
    }

    func test_dismiss_shouldCallNavigatorDismiss() {
        sut.dismiss()

        XCTAssertTrue(navigatorMock.dismissCalled, "dismiss should be called on navigator")
    }
}
