import SwiftUI

extension VerifyView {
    final class ViewModel: ObservableObject {
        @Published var verificationCode: String = ""
        @Published var username: String = ""
        @Published var password: String = ""

        private let navigator: RegisterVerificationViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        func verify() {
            Task {
                await accountService.confirmSignUp(with: verificationCode, username, password)
            }
            navigator.verified()
        }

        init(
            navigator: RegisterVerificationViewNavigatorProtocol,
            accountService: AccountServiceProtocol
        ) {
            self.navigator = navigator
            self.accountService = accountService
        }
    }
}
