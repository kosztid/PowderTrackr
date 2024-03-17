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
        
        func acceptRequest(_ request: FriendRequest) {
            friendRequests.removeAll { $0 == request}
            service.addFriend(request: request)
        }
        
        // TODO: decline request
        func declineRequest(_ request: FriendRequest) {
        }
        
        func refreshRequests() {
            service.queryFriendRequests()
        }
    }
}
