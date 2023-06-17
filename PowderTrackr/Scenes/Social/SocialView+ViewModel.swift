import Combine
import SwiftUI

extension SocialView {
    final class ViewModel: ObservableObject {
        @Published var friendList: Friendlist?
        @Published var notification: Bool

        private let navigator: SocialListViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        init(
            navigator: SocialListViewNavigatorProtocol,
            accountService: AccountServiceProtocol
        ) {
            self.navigator = navigator
            self.accountService = accountService
            self.notification = false
            initFriendList()
            Task {
                await accountService.queryFriends()
                await accountService.queryFriendRequests()
            }
        }

        func initFriendList() {
            accountService.friendListPublisher
                .sink { _ in
                } receiveValue: { [weak self] friendList in
                    self?.friendList = friendList
                }
                .store(in: &cancellables)
        }

        func delete(at offsets: IndexSet) {
            Task {
                friendList?.friends?.remove(atOffsets: offsets)
                guard let list = friendList else { return }
                await accountService.deleteFriend(friendlist: list)
            }
        }

        func updateTracking(id: String) {
            Task {
                await accountService.updateTracking(id: id)
            }
        }

        func navigateToRequests() {
            navigator.navigateToRequest()
        }

        func navigateToAddFriend() {
            navigator.navigateToAdd()
        }
    }
}
