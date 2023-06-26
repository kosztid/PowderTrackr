import Combine
import GoogleMaps
import SwiftUI

extension TrackListView {
    final class ViewModel: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []

        let mapService: MapServiceProtocol
        let accountService: AccountServiceProtocol

        @Published var tracks: [TrackedPath] = []
        @Published var signedIn = false

        init(
            mapService: MapServiceProtocol,
            accountService: AccountServiceProtocol
        ) {
            self.mapService = mapService
            self.accountService = accountService

            mapService.trackedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    self?.tracks = track?.tracks ?? []
                }
                .store(in: &cancellables)

            accountService.isSignedInPublisher
                .sink(receiveValue: { [weak self] value in
                    self?.signedIn = value
                    if !value {
                        self?.tracks = []
                    }
                })
                .store(in: &cancellables)

            Task {
                await mapService.queryTrackedPaths()
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

        func onAppear() {
            Task {
                await mapService.queryTrackedPaths()
            }
        }

        func removeTrack(_ trackedPath: TrackedPath) {
            Task {
                await mapService.removeTrackedPath(trackedPath)
            }
        }

        func updateTrack(_ trackedPath: TrackedPath) {
            Task {
                await mapService.updateTrack(trackedPath)
            }
        }

        func addNote(_ note: String, _ trackedPath: TrackedPath) {
            Task {
                var newTrack = trackedPath
                newTrack.notes?.append(note)
                await mapService.updateTrack(newTrack)
            }
        }
    }
}
