import Combine
import SwiftUI

extension ShareListView {
    final class ViewModel: ObservableObject {
        @Published var friendList: Friendlist?
        let track: TrackedPath

        private let friendService: FriendServiceProtocol
        private let mapService: MapServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        init(
            friendService: FriendServiceProtocol,
            mapService: MapServiceProtocol,
            track: TrackedPath
        ) {
            self.friendService = friendService
            self.mapService = mapService
            self.track = track
            initBindings()
            friendService.queryFriends()
        }

        func initBindings() {
            friendService.friendListPublisher
                .sink { _ in
                } receiveValue: { [weak self] friendList in
                    self?.friendList = friendList
                }
                .store(in: &cancellables)
        }

        func share(with friend: Friend) {
            mapService.shareTrack(track, friend.id)
        }
    }
}
