import Combine
import SwiftUI

extension ChangePasswordView {
    final class ViewModel: ObservableObject {
        @Published var oldPassword: String = ""
        @Published var newPassword: String = ""
        @Published var toast: ToastModel?

        private let navigator: ChangePasswordViewNavigatorProtocol
        private let accountService: AccountServiceProtocol
        
        private var cancellables: Set<AnyCancellable> = []

        func changeButtonTap() {
            accountService.changePassword(
                oldPassword: oldPassword,
                newPassword: newPassword
            )
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard case .failure(_) = completion else { return }
                        self?.toast = .init(title: "Failed changing password", type: .error)
                    }, receiveValue: { [weak self] data in
                        self?.passwordChangedSuccessfully()
                    }
                )
                .store(in: &cancellables)
        }

        func navigateBack() {
            navigator.navigateBack()
        }
        
        func passwordChangedSuccessfully() {
            toast = .init(title: "Password changed successfully", type: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigator.changeButtonTapped()
            }
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
