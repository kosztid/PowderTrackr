import SwiftUI

extension ResetPasswordView {
    final class ViewModel: ObservableObject {
        @Published var username: String = ""

        private let navigator: ResetPasswordViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        func reset() {
            Task {
                await accountService.resetPassword(username: username)
            }
//            navigator.resetButtonTapped(username: username)
        }

        func navigateBack() {
            navigator.navigateBack()
        }

        init(
            navigator: ResetPasswordViewNavigatorProtocol,
            accountService: AccountServiceProtocol
        ) {
            self.navigator = navigator
            self.accountService = accountService
        }
    }
}
