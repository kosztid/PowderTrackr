import Combine
import SwiftUI

extension TrackListView {
    final class ViewModel: ObservableObject {
        var connectivityProvider: WatchConnectivityProvider
        
        private var cancellables: Set<AnyCancellable> = []
        
        private let mapService: MapServiceProtocol
        
        @Published var tracks: [TrackedPath] = []
        @Published var selectedTrack: TrackedPath?
        
        init() {
            self.mapService = MapService()
            self.connectivityProvider = WatchConnectivityProvider()
            
            initBindings()
            
            mapService.queryTrackedPaths(connectivityProvider.userID)
        }
        
        func initBindings() {
            mapService.trackedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    self?.tracks = track?.tracks ?? []
                }
                .store(in: &cancellables)
        }
        
        
        func load() {
            mapService.queryTrackedPaths(connectivityProvider.userID)
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
