import Combine
import SwiftUI

extension RacesView {
    final class ViewModel: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []

        private let navigator: RacesViewNavigatorProtocol
        private let mapService: MapServiceProtocol
        private let friendService: FriendServiceProtocol

        @Published var showingDeleteRaceAlert = false
        @Published var races: [String] = ["Race 123", "Race XYZ", "Race ABC"]
        @Published var friendList: Friendlist?
        @Published var raceToShare: String?
        @Published var raceToDelete: String?

        init(
            mapService: MapServiceProtocol,
            friendService: FriendServiceProtocol,
            navigator: RacesViewNavigatorProtocol
        ) {
            self.mapService = mapService
            self.friendService = friendService
            self.navigator = navigator

            initBindings()

            Task {
                await friendService.queryFriends()
            }
        }

        func initBindings() {
            friendService.friendListPublisher
                .sink { _ in
                } receiveValue: { [weak self] friendList in
                    self?.friendList = friendList
                }
                .store(in: &cancellables)
        }

        func navigateToMyRuns(race: String) {
            navigator.navigateToRaceRuns(race: race)
        }

        func share(with friend: Friend) {
            guard let raceToShare else { return }
            Task {
                //                await mapService.shareRace(raceToShare, friend.id)
            }
        }

        func openShare(for race: String) {
            withAnimation {
                raceToShare = race
            }
        }

        func refreshRaces() {
            raceToDelete = nil
            races = ["Race 123", "Race XYZ", "Race ABC"]
        }

        func deleteRace() {
            withAnimation {
                races.removeAll { $0 == raceToDelete}
                raceToDelete = nil
            }
            print("race Deleted")
        }
    }
}
