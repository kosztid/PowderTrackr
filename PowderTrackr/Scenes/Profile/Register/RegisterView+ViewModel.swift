import Combine
import SwiftUI

extension RegisterView {
    final class ViewModel: ObservableObject {
        @Published var username: String = ""
        @Published var email: String = ""
        @Published var password: String = ""
        @Published var toast: ToastModel?

        private let navigator: RegisterViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        func register() {
            accountService.register(username, email, password).sink(
                receiveCompletion: { [weak self] completion in
                    guard case .failure = completion else { return }
                    self?.toast = .init(title: "Failed to register", type: .error)
                }, receiveValue: { [weak self] _ in
                    guard let self else { return }
                    self.navigator.registered(username: self.username, password: self.password)
                }
            )
            .store(in: &cancellables)
        }

        func dismiss() {
            navigator.dismiss()
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
