import Combine
import SwiftUI
import AWSCognitoIdentityProvider

extension LoginView {
    final class ViewModel: ObservableObject {
        @Published var showLoginError = false
        @Published var isSignedIn = false
        @Published var userName: String = "kosztidominik"
        @Published var password: String = "kosztidominik"

        private var cancellables: Set<AnyCancellable> = []
        private let navigator: LoginViewNavigatorProtocol
        private let accountService: AccountServiceProtocol
        
        
        func loginUser() {
                let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
            let user = pool!.getUser(userName)
                user.getSession(userName, password: password, validationData: nil).continueWith { (task) -> Any? in
                    if let error = task.error {
                        print("Login failed with error: \(error)")
                    } else {
                        print("Login successful")
                    }
                    return nil
                }
            }
        
        func login() {
            accountService.signIn(userName, password)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard case .failure(let error) = completion else { return }
                        print(error)
                        self?.showLoginError = true
                    }, receiveValue: { [weak self] _ in
                        self?.navigator.loggedIn()
                    }
                )
                .store(in: &cancellables)
        }

        func resetPassword() {
            navigator.navigateToResetPassword()
        }

        func dismiss() {
            navigator.dismiss()
        }

        func bindPublishers() {
            accountService.isSignedInPublisher
                .sink { _ in
                } receiveValue: { [weak self] isSignedIn in
                    self?.isSignedIn = isSignedIn
                }
                .store(in: &cancellables)
        }

        init(
            navigator: LoginViewNavigatorProtocol,
            accountService: AccountServiceProtocol
        ) {
            self.navigator = navigator
            self.accountService = accountService
            bindPublishers()
        }
    }
}
