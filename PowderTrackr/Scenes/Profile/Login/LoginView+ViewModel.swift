import Combine
import SwiftUI

extension LoginView {
    final class ViewModel: ObservableObject {
        @Published var isSignedIn = false
        @Published var userName: String = ""
        @Published var password: String = ""

        private var cancellables: Set<AnyCancellable> = []
        private let navigator: LoginViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        func login() {
            Task {
//                await accountService.login()
                await accountService.signIn(userName, password)
            }
            navigator.loggedIn()
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
