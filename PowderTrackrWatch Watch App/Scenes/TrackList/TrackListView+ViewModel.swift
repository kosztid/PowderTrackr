import Combine
import SwiftUI

extension TrackListView {
    final class ViewModel: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []
        
        private let mapService: MapServiceProtocol
        private let dataService: DataService

        @Published var tracks: [TrackedPath] = []
        
        @AppStorage("id", store: UserDefaults(suiteName: "group.koszti.PowderTrackr")) var userID: String = ""
        
        init() {
            self.mapService = MapService()
            self.dataService = DataService()
            
            initBindings()
            
            mapService.queryTrackedPaths()
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
            mapService.queryTrackedPaths()
        }
    }
}
