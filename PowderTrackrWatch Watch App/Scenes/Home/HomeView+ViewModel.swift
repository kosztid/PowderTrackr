import Combine
import Foundation

extension HomeView {
    final class ViewModel: ObservableObject {
        var connectivityProvider: WatchConnectivityProvider

        @Published var isTracking = false
        @Published var elapsedTime: Double = 0.0
        @Published var avgSpeed: Double = 0.0
        @Published var distance: Double = 0.0

        private var cancellables: Set<AnyCancellable> = []

        init() {
            self.connectivityProvider = WatchConnectivityProvider()
            setupSubscriptions()
        }

        private func setupSubscriptions() {
            connectivityProvider.$isTracking
                .receive(on: DispatchQueue.main)
                .assign(to: \.isTracking, on: self)
                .store(in: &cancellables)

            connectivityProvider.$elapsedTime
                .receive(on: DispatchQueue.main)
                .assign(to: \.elapsedTime, on: self)
                .store(in: &cancellables)

            connectivityProvider.$avgSpeed
                .receive(on: DispatchQueue.main)
                .assign(to: \.avgSpeed, on: self)
                .store(in: &cancellables)

            connectivityProvider.$distance
                .receive(on: DispatchQueue.main)
                .assign(to: \.distance, on: self)
                .store(in: &cancellables)
        }

        func stopTracking() {
            connectivityProvider.sendIsTracking(isTracking: false)
        }

        func startTracking() {
            connectivityProvider.sendIsTracking(isTracking: true)
        }
    }
}
