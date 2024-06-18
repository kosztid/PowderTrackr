import Combine
import SwiftUI

extension ResetPasswordView {
    final class ViewModel: ObservableObject {
        @Published var username: String = ""
        @Published var toast: ToastModel?

        private let navigator: ResetPasswordViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        func reset() {
            accountService.resetPassword(username: username)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard case .failure = completion else { return }
                        self?.toast = .init(title: "Failed resetting password", type: .error)
                    }, receiveValue: { [weak self] _ in
                        self?.toast = .init(title: "Password reset sent", type: .success)
                        self?.navigateToReset()
                    }
                )
                .store(in: &cancellables)
        }

        func navigateBack() {
            navigator.navigateBack()
        }

        func navigateToReset() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigator.resetButtonTapped(username: self.username)
            }
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
