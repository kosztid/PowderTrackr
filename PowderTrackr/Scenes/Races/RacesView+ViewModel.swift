import Combine
import GoogleMaps
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
        @Published var raceToShare: Race?
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
                    self?.updateShortestRun()
                }
                .store(in: &cancellables)
        }

        func navigateToMyRuns(race: Race) {
            navigator.navigateToRaceRuns(race: race)
        }

        func share(with friend: Friend) {
            guard let raceToShare else { return }
            Task {
                await mapService.shareRace(friend.id, raceToShare)
            }
        }

        func openShare(for race: Race) {
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
            guard let race = races.first(where: { $0.id == raceToDelete }) else { return }
            withAnimation {
                races.removeAll { $0.id == raceToDelete}
                raceToDelete = nil
            }
            Task {
                await mapService.deleteRace(race)
            }
        }

        func updateShortestRun() {
            races.forEach { race in
                var time = race.shortestTime
                var distance = race.shortestDistance
                var newRace = race
                for run in race.tracks ?? [] {
                    let startDate = dateFormatter.date(from: run.startDate)
                    let endDate = dateFormatter.date(from: run.endDate)
                    guard let endDate else { return }
                    let current = startDate?.distance(to: endDate) ?? 0.0
                    let currentDistance = calculateDistance(track: run)
                    if current < time {
                        time = current
                    }
                    if currentDistance < distance {
                        distance = currentDistance
                    }
                }

                newRace.shortestTime = time
                newRace.shortestDistance = distance

                if race.shortestTime > time || race.shortestDistance > distance {
                    newRace.shortestTime = time
                    updateRace(race: race, newRace: newRace)
                }
            }
        }

        func updateRace(race: Race, newRace: Race) {
            Task {
                await mapService.updateRace(race, newRace)
            }
        }

        func calculateDistance(track: TrackedPath) -> Double {
            var list: [CLLocation] = []
            var distance = 0.0
            for index in 0..<(track.xCoords?.count ?? 0) {
                list.append(CLLocation(latitude: track.xCoords?[index] ?? 0, longitude: track.yCoords?[index] ?? 0))
            }
            for itemDx in 1..<list.count {
                distance += list[itemDx].distance(from: list[itemDx - 1])
            }
            return distance
        }
    }
}
