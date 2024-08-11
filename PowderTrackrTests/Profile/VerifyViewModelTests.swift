import Combine
@testable import PowderTrackr
import XCTest

final class VerifyViewModelTests: XCTestCase {
    private var sut: VerifyView.ViewModel!
    private var navigatorMock: RegisterVerificationViewNavigatorProtocolMock!
    private var accountServiceMock: AccountServiceProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = []
        navigatorMock = RegisterVerificationViewNavigatorProtocolMock()
        accountServiceMock = AccountServiceProtocolMock()
        let inputModel = VerifyView.InputModel(username: "testuser", password: "password123")

        sut = VerifyView.ViewModel(
            navigator: navigatorMock,
            accountService: accountServiceMock,
            inputModel: inputModel
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        navigatorMock = nil
        accountServiceMock = nil
        cancellables = nil
        super.tearDown()
    }

    func test_verify_whenConfirmationSucceeds_navigatesToVerifiedView() {
        accountServiceMock.confirmSignUpWithReturnValue = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()

        sut.$toast
            .sink { toast in
                if toast != nil {
                    XCTFail()
                }
            }
            .store(in: &cancellables)

        sut.verify()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.navigatorMock.verifiedCalled)
        }
    }

    func test_verify_whenConfirmationFails_showsErrorMessage() {
        let expectation = XCTestExpectation(description: "Show error message")

        accountServiceMock.confirmSignUpWithReturnValue = Fail<Void, Error>(error: NSError(domain: "", code: -1, userInfo: nil)).eraseToAnyPublisher()

        sut.$toast
            .sink { toast in
                if let toast = toast, toast.title == "Failed to confirm registration" {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        sut.verify()

        wait(for: [expectation], timeout: 2.0)
    }
}
