import SwiftUI

extension FriendAddView {
    final class ViewModel: ObservableObject {
        private let navigator: SocialAddViewNavigatorProtocol
        private let service: FriendServiceProtocol
        @Published var email: String = ""

        init(
            navigator: SocialAddViewNavigatorProtocol,
            service: FriendServiceProtocol
        ) {
            self.navigator = navigator
            self.service = service
        }

        func addFriend() {
            service.sendFriendRequest(recipient: email)
            navigator.navigateBack()
        }
    }
}
