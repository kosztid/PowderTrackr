import Combine
@testable import PowderTrackr
import XCTest

final class RegisterViewModelTests: XCTestCase {
    private var sut: RegisterView.ViewModel!
    private var navigatorMock: RegisterViewNavigatorProtocolMock!
    private var accountServiceMock: AccountServiceProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = []
        navigatorMock = RegisterViewNavigatorProtocolMock()
        accountServiceMock = AccountServiceProtocolMock()

        sut = RegisterView.ViewModel(
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

    func test_register_whenSuccess_callsRegisteredOnNavigator() {
        let expect = expectation(description: "Navigator called for successful registration")

        accountServiceMock.registerReturnValue = Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()

        sut.username = "testuser"
        sut.password = "password123"

        sut.$toast
            .sink { toast in
                if toast != nil {
                    XCTFail("No toast should be displayed on successful registration")
                }
            }
            .store(in: &cancellables)

        sut.register()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.navigatorMock.registeredUsernamePasswordCalled)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2.0)
    }

    func test_register_whenFailure_displaysToast() {
        let expect = expectation(description: "Toast displayed on registration failure")

        accountServiceMock.registerReturnValue = Fail<Void, Error>(error: NSError(domain: "", code: -1, userInfo: nil)).eraseToAnyPublisher()

        sut.register()

        sut.$toast
            .sink { toast in
                if let toast = toast, toast.title == "Failed to register" {
                    expect.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expect], timeout: 1.0)
    }

    func test_dismiss_whenCalled_triggersNavigationBack() {
        sut.dismiss()

        XCTAssertTrue(navigatorMock.dismissCalled, "dismiss should be called on the navigator to navigate back")
    }
}
