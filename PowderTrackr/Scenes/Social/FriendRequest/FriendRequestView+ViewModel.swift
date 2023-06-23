import Combine
import SwiftUI

extension FriendRequestView {
    final class ViewModel: ObservableObject {
        @Published var friendRequests: [FriendRequest] = []

        private let service: FriendServiceProtocol
        private var cancellables: Set<AnyCancellable> = []

        init(service: FriendServiceProtocol) {
            self.service = service

            initFriendRequests()
        }

        func initFriendRequests() {
            service.friendRequestsPublisher
                .sink { _ in
                } receiveValue: { [weak self] requests in
                    self?.friendRequests = requests
                }
                .store(in: &cancellables)
        }

        func addFriend(request: FriendRequest) {
            Task {
                await service.addFriend(request: request)
            }
        }

        func refreshRequests() {
            Task {
                await service.queryFriendRequests()
            }
        }
    }
}
