import Combine
import GoogleMaps
import SwiftUI

extension MyRunsView {
    final class ViewModel: ObservableObject {
        let title: String
        let allRuns: Race
        @Published var raceRuns: [TrackedPath] = []
        @Published var raceClosestRuns: [TrackedPath?] = []

        private let accountService: AccountServiceProtocol
        var userID: String {
            UserDefaults(suiteName: "group.koszti.storedData")?.string(forKey: "id") ?? ""
        }

        private var cancellables: Set<AnyCancellable> = []

        init(
            race: Race,
            accountService: AccountServiceProtocol
        ) {
            self.allRuns = race
            self.title = race.name
            self.accountService = accountService
            self.getClosestRuns()
        }

        func getClosestRuns() {
            raceRuns = []
            allRuns.tracks?.forEach { race in
                if let racerId = race.notes?.first {
                    if racerId == userID {
                        raceRuns.append(race)
                    }
                }
            }

            raceClosestRuns = []
            raceRuns.forEach { race in
                guard let tracks = allRuns.tracks else { return }
                raceClosestRuns.append(
                    tracks
                        .filter { opponentRun in
                            opponentRun.notes?.first != userID
                        }
                        .min { abs(calculateDistance($0) - calculateDistance(race)) < abs(calculateDistance($1) - calculateDistance(race)) }
                )
            }
        }

        func calculateDistance(_ track: TrackedPath) -> Double {
            var list: [CLLocation] = []
            var distance = Double.zero
            for index in .zero..<(track.xCoords?.count ?? .zero) {
                list.append(CLLocation(latitude: track.xCoords?[index] ?? .zero, longitude: track.yCoords?[index] ?? .zero))
            }
            for itemDx in 1..<list.count {
                distance += list[itemDx].distance(from: list[itemDx - 1])
            }
            return distance
        }
    }
}
