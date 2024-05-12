import Foundation

extension TrackListView {
    final class ViewModel: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []
        
        private let mapService: MapServiceProtocol
        @Published var tracks: [TrackedPath] = []
        
        init() {
            self.mapService = MapService()
            
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
    }
}
