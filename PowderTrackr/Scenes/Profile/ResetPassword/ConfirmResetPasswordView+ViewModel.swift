import SwiftUI

extension ConfirmResetPasswordView {
    final class ViewModel: ObservableObject {
        @Published var verificationCode: String = ""
        @Published var username: String
        @Published var password: String = ""

        private let navigator: RegisterVerificationViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        func verify() {
            Task {
                await accountService.confirmResetPassword(username: username,newPassword: password, confirmationCode: verificationCode)
            }
            navigator.verified()
        }

        init(
            navigator: RegisterVerificationViewNavigatorProtocol,
            accountService: AccountServiceProtocol,
            username: String
        ) {
            self.navigator = navigator
            self.accountService = accountService
            self.username = username
        }
    }
}
