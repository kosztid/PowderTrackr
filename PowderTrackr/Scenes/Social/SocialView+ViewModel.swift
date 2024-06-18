import Combine
import SwiftUI

extension SocialView {
    public struct LastMessageModel {
        public let id: String
        public let message: Message?

        public init(id: String, message: Message?) {
            self.id = id
            self.message = message
        }
    }
    struct InputModel {
        let navigateToAccount: () -> Void
    }

    final class ViewModel: ObservableObject {
        @Published var friendList: Friendlist?
        @Published var groupList = ["asd", "asd"]
        @Published var notification: Bool
        @Published var signedIn = false
        @Published var chatNotifications: [String] = []
        @Published var lastMessages: [LastMessageModel] = []

        private let navigator: SocialListViewNavigatorProtocol
        private let friendService: FriendServiceProtocol
        private let accountService: AccountServiceProtocol
        private let chatService: ChatServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        let inputModel: InputModel

        init(
            navigator: SocialListViewNavigatorProtocol,
            friendService: FriendServiceProtocol,
            accountService: AccountServiceProtocol,
            chatService: ChatServiceProtocol,
            inputModel: InputModel
        ) {
            self.navigator = navigator
            self.friendService = friendService
            self.accountService = accountService
            self.chatService = chatService
            self.notification = false
            self.inputModel = inputModel
            initBindings()
        }

        func initBindings() {
            friendService.friendListPublisher
                .sink { _ in
                } receiveValue: { [weak self] friendList in
                    guard let self else { return }
                    if self.signedIn {
                        self.friendList = friendList
                    } else {
                        self.friendList = nil
                    }
                }
                .store(in: &cancellables)

            friendService.friendRequestsPublisher
                .sink { _ in
                } receiveValue: { [weak self] requests in
                    guard let self else { return }
                    if self.signedIn {
                        if !requests.isEmpty {
                            self.notification = true
                        } else {
                            self.notification = false
                        }
                    } else {
                        self.notification = false
                    }
                }
                .store(in: &cancellables)

            accountService.isSignedInPublisher
                .sink { _ in
                } receiveValue: { [weak self] signedIn in
                    self?.signedIn = signedIn
                    if !signedIn {
                        self?.friendList = nil
                    } else {
                        self?.onAppear()
                    }
                }
                .store(in: &cancellables)

            chatService.chatNotificationPublisher
                .sink { _ in
                } receiveValue: { [weak self] notifications in
                    guard let self else { return }
                    if self.signedIn {
                        self.chatNotifications = notifications ?? []
                    } else {
                        self.chatNotifications = []
                    }
                }
                .store(in: &cancellables)

            chatService.lastMessagesPublisher
                .sink { _ in
                } receiveValue: { [weak self] array in
                    self?.lastMessages = array ?? []
                }
                .store(in: &cancellables)
        }

        func removeFriend(friend: Friend) {
            friendList?.friends?.removeAll { $0.id == friend.id }
            friendService.deleteFriend(friend: friend)
        }

        func updateTracking(id: String) {
            friendService.updateTracking(id: id)
        }

        func navigateToRequests() {
            navigator.navigateToRequest()
        }

        func navigateToAddFriend() {
            friendService.getAddableUsers()
                .sink(
                    receiveCompletion: { completion in
                        guard case .failure(let error) = completion else { return }
                        print(error)
                    }, receiveValue: { [weak self] users in
                        self?.navigator.navigateToAdd(users: users)
                    }
                )
                .store(in: &cancellables)
        }

        func navigateToChatWithFriend(friendId: String, friendName: String) {
            navigator.navigateToChat(model: .init(chatId: friendId, names: [friendName]))
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
            friendService.queryFriends()
            friendService.queryFriendRequests()
        }

        func lastMessage(for id: String) -> Message? {
            lastMessages.first { $0.id == id }?.message
        }

        func notification(for friendId: String) -> Bool {
            chatNotifications.contains(friendId)
        }
    }
}
