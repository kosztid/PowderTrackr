import Combine
import SwiftUI

public extension FriendAddView {
    struct InputModel {
        let users: [User]
    }

    final class ViewModel: ObservableObject {
        @Published var users: [User] = []
        @Published var toast: ToastModel?
        @Published var searchText: String = ""

        var filteredUsers: [User] {
            if searchText.isEmpty {
                return users
            } else {
                return users.filter { user in
                    user.name.localizedCaseInsensitiveContains(searchText) ||
                    user.email.localizedCaseInsensitiveContains(searchText)
                }
            }
        }

        private let navigator: SocialAddViewNavigatorProtocol
        private let service: FriendServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        let model: InputModel

        init(
            navigator: SocialAddViewNavigatorProtocol,
            service: FriendServiceProtocol,
            model: InputModel
        ) {
            self.navigator = navigator
            self.service = service
            self.model = model
            self.users = model.users
        }

        func addFriend(user: User) {
            service.sendFriendRequest(recipient: user.id)
                .sink(
                    receiveCompletion: { completion in
                        guard case .failure(let error) = completion else { return }
                    }, receiveValue: { [weak self] _ in
                        self?.toast = .init(title: "Friendrequest sent to \(user.name)", type: .success)
                        self?.users.removeAll { $0.id == user.id }
                    }
                )
                .store(in: &cancellables)
        }

        func dismissButtonTap() {
            navigator.navigateBack()
        }
    }
}
