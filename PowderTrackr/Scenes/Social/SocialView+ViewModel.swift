import Combine
import SwiftUI

extension SocialView {
    final class ViewModel: ObservableObject {
        @Published var friendList: Friendlist?
        @Published var groupList = ["asd", "asd"]
        @Published var notification: Bool
        @Published var signedIn: Bool = false
        @Published var chatNotifications: [String] = []

        private let navigator: SocialListViewNavigatorProtocol
        private let friendService: FriendServiceProtocol
        private let accountService: AccountServiceProtocol
        private let chatService: ChatServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        init(
            navigator: SocialListViewNavigatorProtocol,
            friendService: FriendServiceProtocol,
            accountService: AccountServiceProtocol,
            chatService: ChatServiceProtocol
        ) {
            self.navigator = navigator
            self.friendService = friendService
            self.accountService = accountService
            self.chatService = chatService
            self.notification = false
            initBindings()
            friendService.queryFriends()
            friendService.queryFriendRequests()
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

            chatService.chatNotificationPublisher
                .sink { _ in
                } receiveValue: { [weak self] notifications in
                    self?.chatNotifications = notifications ?? []
                }
                .store(in: &cancellables)
        }

        func removeFriend(friend: Friend) {
            friendList?.friends?.removeAll { $0.id == friend.id}
            friendService.deleteFriend(friend: friend)
        }

        func updateTracking(id: String) {
            friendService.updateTracking(id: id)
        }

        func navigateToRequests() {
            navigator.navigateToRequest()
        }

        func navigateToAddFriend() {
            navigator.navigateToAdd()
        }

        func navigateToChatWithFriend(friendId: String) {
            navigator.navigateToChat(recipient: friendId)
        }
        
        func queryChatNotifications() {
            chatService.getChatNotifications()
        }
        func navigateToChatGroup(groupId: String) {
//            Task {
//                await chatService.chatIdForGroup(for: groupId)
//            }
//            navigator.navigateToChat()
        }

        func onAppear() {
            queryChatNotifications()
        }

        func notification(for friendId: String) -> Bool {
            chatNotifications.contains(friendId)
        }
    }
}
