import AWSCognitoIdentityProvider
import Combine
import GoogleMaps
import SwiftUI

extension RacesView {
    struct InputModel {
        let navigateToAccount: () -> Void
    }

    final class ViewModel: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []

        let dateFormatter = DateFormatter()
        let inputModel: InputModel
        
        var userID: String {
            UserDefaults(suiteName: "group.koszti.storedData")?.string(forKey: "id") ?? ""
        }
        private let navigator: RacesViewNavigatorProtocol
        private let mapService: MapServiceProtocol
        private let friendService: FriendServiceProtocol
        private let accountService: AccountServiceProtocol

        @Published var user: AWSCognitoIdentityUser?
        @Published var signedIn = false
        @Published var showingDeleteRaceAlert = false
        @Published var races: [Race] = []
        @Published var friendList: Friendlist?
        @Published var raceToShare: Race?
        @Published var raceToDelete: String?

        init(
            mapService: MapServiceProtocol,
            friendService: FriendServiceProtocol,
            accountService: AccountServiceProtocol,
            navigator: RacesViewNavigatorProtocol,
            inputModel: InputModel
        ) {
            self.mapService = mapService
            self.friendService = friendService
            self.accountService = accountService
            self.navigator = navigator
            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.inputModel = inputModel

            initBindings()
        }

        func initBindings() {
            accountService.userPublisher
                .sink { _ in
                } receiveValue: { [weak self] user in
                    guard let user = user else { return }
                    self?.user = user
                }
                .store(in: &cancellables)

            accountService.isSignedInPublisher
                .sink(receiveValue: { [weak self] value in
                    self?.signedIn = value
                })
                .store(in: &cancellables)

            friendService.friendListPublisher
                .sink { _ in
                } receiveValue: { [weak self] friendList in
                    self?.friendList = friendList
                }
                .store(in: &cancellables)

            mapService.racesPublisher
                .sink { _ in
                } receiveValue: { [weak self] races in
                    guard let self else { return }
                    if self.signedIn {
                        self.races = races
                    } else {
                        self.races = []
                    }

                    self.updateShortestRun()
                }
                .store(in: &cancellables)
        }

        func navigateToMyRuns(race: Race) {
            navigator.navigateToRaceRuns(race: race)
        }

        func share(with friend: Friend) {
            guard let raceToShare else { return }
            mapService.shareRace(friend.id, raceToShare)
        }

        func openShare(for race: Race) {
            withAnimation {
                raceToShare = race
            }
        }

        func refreshRaces() {
            raceToDelete = nil
            mapService.queryRaces()
        }

        func deleteRace() {
            guard let race = races.first(where: { $0.id == raceToDelete }) else { return }
            withAnimation {
                races.removeAll { $0.id == raceToDelete }
                raceToDelete = nil
            }
            mapService.deleteRace(race)
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
                    if current < time || time == -1 {
                        time = current
                    }
                    if currentDistance < distance || distance == -1 {
                        distance = currentDistance
                    }
                }

                newRace.shortestTime = time
                newRace.shortestDistance = distance

                if race.shortestTime == -1 || race.shortestTime > time || race.shortestDistance > distance {
                    newRace.shortestTime = time
                    newRace.shortestDistance = distance
                    updateRace(race: race, newRace: newRace)
                }
            }
        }

        func updateRace(race: Race, newRace: Race) {
            mapService.updateRace(race, newRace)
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
