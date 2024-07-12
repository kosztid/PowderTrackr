import Combine
import SwiftUI

extension ConfirmResetPasswordView {
    final class ViewModel: ObservableObject {
        @Published var verificationCode: String = ""
        @Published var username: String
        @Published var password: String = ""
        @Published var toast: ToastModel?

        private let navigator: RegisterVerificationViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        func verify() {
            accountService.confirmResetPassword(username: username, newPassword: password, confirmationCode: verificationCode)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard case .failure = completion else { return }
                        self?.toast = .init(title: "Failed resetting password", type: .error)
                    }, receiveValue: { [weak self] _ in
                        self?.navigator.verified()
                    }
                )
                .store(in: &cancellables)
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
