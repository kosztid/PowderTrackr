import SwiftUI

extension RegisterView {
    final class ViewModel: ObservableObject {
        @Published var userName: String = ""
        @Published var email: String = ""
        @Published var password: String = ""

        private let navigator: RegisterViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        func register() {
            Task {
                await accountService.signUp(userName, email, password)
            }
            navigator.registered()
        }

        init(
            navigator: RegisterViewNavigatorProtocol,
            accountService: AccountServiceProtocol
        ) {
            self.navigator = navigator
            self.accountService = accountService
        }
    }
}
