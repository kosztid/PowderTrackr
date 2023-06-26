import Combine
import SwiftUI

extension SocialView {
    final class ViewModel: ObservableObject {
        @Published var friendList: Friendlist?
        @Published var notification: Bool
        @Published var signedIn: Bool = false

        private let navigator: SocialListViewNavigatorProtocol
        private let friendService: FriendServiceProtocol
        private let accountService: AccountServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        init(
            navigator: SocialListViewNavigatorProtocol,
            friendService: FriendServiceProtocol,
            accountService: AccountServiceProtocol
        ) {
            self.navigator = navigator
            self.friendService = friendService
            self.accountService = accountService
            self.notification = false
            initBindings()
            Task {
                await friendService.queryFriends()
                await friendService.queryFriendRequests()
            }
        }

        func initBindings() {
            friendService.friendListPublisher
                .sink { _ in
                } receiveValue: { [weak self] friendList in
                    self?.friendList = friendList
                }
                .store(in: &cancellables)

            accountService.isSignedInPublisher
                .sink { _ in
                } receiveValue: { [weak self] signedIn in
                    self?.signedIn = signedIn
                    if !signedIn {
                        self?.friendList = nil
                    }
                }
                .store(in: &cancellables)
        }

        func delete(at offsets: IndexSet) {
            Task {
                friendList?.friends?.remove(atOffsets: offsets)
                guard let list = friendList else { return }
                await friendService.deleteFriend(friendlist: list)
            }
        }

        func updateTracking(id: String) {
            Task {
                await friendService.updateTracking(id: id)
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
