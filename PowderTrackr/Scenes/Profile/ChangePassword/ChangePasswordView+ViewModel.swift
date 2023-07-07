import SwiftUI

extension ChangePasswordView {
    final class ViewModel: ObservableObject {
        @Published var oldPassword: String = ""
        @Published var newPassword: String = ""

        private let navigator: ChangePasswordViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        func changeButtonTap() {
            Task {
                await accountService.changePassword(oldPassword: oldPassword, newPassword: newPassword)
            }
            navigator.changeButtonTapped()
        }

        func navigateBack() {
            navigator.navigateBack()
        }

        init(
            navigator: ChangePasswordViewNavigatorProtocol,
            accountService: AccountServiceProtocol
        ) {
            self.navigator = navigator
            self.accountService = accountService
        }
    }
}
