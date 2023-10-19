import Amplify
import Combine
import GoogleMaps
import SwiftUI

extension MyRunsView {
    final class ViewModel: ObservableObject {
        let title: String
        let allRuns: Race
        @Published var raceRuns: [TrackedPath] = []
        @Published var raceClosestRuns: [TrackedPath?] = []
        @Published var user: AuthUser?

        private let accountService: AccountServiceProtocol

        private var cancellables: Set<AnyCancellable> = []

        init(
            race: Race,
            accountService: AccountServiceProtocol
        ) {
            self.allRuns = race
            self.title = race.name
            self.accountService = accountService

            accountService.userPublisher
                .sink { _ in
                } receiveValue: { [weak self] user in
                    guard let user = user else { return }
                    self?.user = user
                    self?.getClosestRuns()
                }
                .store(in: &cancellables)
            Task {
                await accountService.getUser()
            }
        }

        func getClosestRuns() {
            allRuns.tracks?.forEach { race in
                if let racerId = race.notes?.first {
                    if racerId == user?.userId {
                        raceRuns.append(race)
                    }
                }
            }

            raceRuns.forEach { race in
                guard let tracks = allRuns.tracks else { return }
                raceClosestRuns.append(
                    tracks
                        .filter { opponentRun in
                            opponentRun.notes?.first != user?.userId
                        }
                        .min { abs(calculateDistance($0) - calculateDistance(race)) < abs(calculateDistance($1) - calculateDistance(race)) }
                )
            }
        }

        func calculateDistance(_ track: TrackedPath) -> Double {
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
