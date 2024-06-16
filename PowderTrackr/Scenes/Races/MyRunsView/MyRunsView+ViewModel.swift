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
        @AppStorage("id", store: UserDefaults(suiteName: "group.koszti.PowderTrackr")) var userID: String = ""


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
