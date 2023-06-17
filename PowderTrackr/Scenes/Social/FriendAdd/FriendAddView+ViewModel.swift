import SwiftUI

extension FriendAddView {
    final class ViewModel: ObservableObject {
        private let navigator: SocialAddViewNavigatorProtocol
        private let service: AccountServiceProtocol
        @Published var email: String = ""

        init(
            navigator: SocialAddViewNavigatorProtocol,
            service: AccountServiceProtocol
        ) {
            self.navigator = navigator
            self.service = service
        }

        func addFriend() {
            Task {
                await service.sendFriendRequest(recipient: email)
            }
            navigator.navigateBack()
        }
    }
}
