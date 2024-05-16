import Combine
import SwiftUI

extension TrackListView {
    final class ViewModel: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []
        
        private let mapService: MapServiceProtocol
        private var connectivityProvider: WatchConnectivityProvider
        @Published var tracks: [TrackedPath] = []
        
        @AppStorage("id", store: UserDefaults(suiteName: "group.koszti.PowderTrackr")) var userID: String = ""
        
        init() {
            self.mapService = MapService()
            self.connectivityProvider = WatchConnectivityProvider()
            
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
            
            connectivityProvider.$userID
                .receive(on: DispatchQueue.main)
                .assign(to: \.userID, on: self)
                .store(in: &cancellables)
        }
        
        
        func load() {
            mapService.queryTrackedPaths()
            print("ServiceID", connectivityProvider.userID)
            print("id: \(userID)")
        }
    }
}
