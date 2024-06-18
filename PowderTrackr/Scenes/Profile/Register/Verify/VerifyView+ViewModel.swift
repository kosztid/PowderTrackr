import Combine
import SwiftUI

extension VerifyView {
   public struct InputModel {
        let username: String
        let password: String
    }

    final class ViewModel: ObservableObject {
        @Published var verificationCode: String = ""
        @Published var username: String = ""
        @Published var password: String = ""
        @Published var toast: ToastModel?

        private let navigator: RegisterVerificationViewNavigatorProtocol
        private let accountService: AccountServiceProtocol
        private let inputModel: InputModel

        private var cancellables: Set<AnyCancellable> = []

        func verify() {
            accountService.confirmSignUp(with: verificationCode, inputModel.username, inputModel.password)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        guard case .failure = completion else { return }
                        self?.toast = .init(title: "Failed to confirm registration", type: .error)
                    }, receiveValue: { [weak self] _ in
                        self?.navigator.verified()
                    }
                )
                .store(in: &cancellables)
        }

        init(
            navigator: RegisterVerificationViewNavigatorProtocol,
            accountService: AccountServiceProtocol,
            inputModel: InputModel
        ) {
            self.navigator = navigator
            self.accountService = accountService
            self.inputModel = inputModel
        }
    }
}
