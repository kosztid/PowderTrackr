import Combine
import SwiftUI

public extension FriendAddView {
    struct InputModel {
        let users: [User]
    }
    
    final class ViewModel: ObservableObject {
        @Published var users: [User] = []
        @Published var toast: ToastModel?
        
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
            self.users = model.users.filter { $0.id != UserDefaults.standard.string(forKey: "id") ?? "" }
        }
        
        func addFriend(user: User) {
            service.sendFriendRequest(recipient: user.email)
                .sink(
                    receiveCompletion: { completion in
                        guard case .failure(let error) = completion else { return }
                        print(error)
                    }, receiveValue: { [weak self] users in
                        self?.toast = .init(title: "Friendrequest sent to \(user.name)", type: .success)
                    }
                )
                .store(in: &cancellables)
        }
        
        func navigateBack() {
            navigator.navigateBack()
        }
    }
}
