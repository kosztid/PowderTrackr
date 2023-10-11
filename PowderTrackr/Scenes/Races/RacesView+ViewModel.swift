import Combine
import SwiftUI

extension RacesView {
    final class ViewModel: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []

        let dateFormatter = DateFormatter()
        private let navigator: RacesViewNavigatorProtocol
        private let mapService: MapServiceProtocol
        private let friendService: FriendServiceProtocol

        @Published var showingDeleteRaceAlert = false
        @Published var races: [Race] = []
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
            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            initBindings()

            Task {
                await friendService.queryFriends()
                await mapService.queryRaces()
            }
        }

        func initBindings() {
            friendService.friendListPublisher
                .sink { _ in
                } receiveValue: { [weak self] friendList in
                    self?.friendList = friendList
                }
                .store(in: &cancellables)

            mapService.racesPublisher
                .sink { _ in
                } receiveValue: { [weak self] races in
                    self?.races = races
                }
                .store(in: &cancellables)
        }

        func navigateToMyRuns(race: String) {
            navigator.navigateToRaceRuns(runs: [], title: race)
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
            Task {
                await mapService.queryRaces()
            }
        }

        func deleteRace() {
            withAnimation {
                races.removeAll { $0.id == raceToDelete}
                raceToDelete = nil
            }
            print("race Deleted")
        }

        func updateShortestRun() {
            races.forEach { race in
                var time = 0
                for run in race.tracks ?? [] {
                    let startDate = dateFormatter.date(from: run.startDate)
                    let endDate = dateFormatter.date(from: run.endDate)
                    guard let endDate else { return }
                    var current = Int(startDate?.distance(to: endDate) ?? 0)
                    if current > time {
                        time = current
                    }
                }
                if Int(race.shortestTime) > time {
                    var newRace = race
                    newRace.shortestTime = Double(time)
                    updateRace(race: race, newRace: newRace)
                }
            }
        }

        func updateRace(race: Race, newRace: Race) {
            Task {
                await mapService.updateRace(race, newRace)
            }
        }
    }
}
