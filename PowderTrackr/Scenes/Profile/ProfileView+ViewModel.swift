import Combine
import CoreLocation
import GoogleMaps
import SwiftUI

extension ProfileView {
    final class ViewModel: ObservableObject {
        @Published var isSignedIn = false
        @Published var currentEmail: String
        @Published var userName: String
        @Published var tracks: [TrackedPath] = []
        @Published var totalDistance: Double = .zero
        @Published var totalTime: String = ""

        let dateFormatter = DateFormatter()
        let formatter = DateComponentsFormatter()
        private var cancellables: Set<AnyCancellable> = []
        private let navigator: ProfileViewNavigatorProtocol
        private let accountService: AccountServiceProtocol
        private let mapService: MapServiceProtocol

        init(
            navigator: ProfileViewNavigatorProtocol,
            accountService: AccountServiceProtocol,
            mapService: MapServiceProtocol
        ) {
            self.navigator = navigator
            self.accountService = accountService
            self.mapService = mapService
            currentEmail = "..."
            userName = "..."

            bindPublishers()

            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .abbreviated
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }

        func logout() {
            Task {
                await accountService.signOut()
                mapService.queryTrackedPaths()
            }
        }

        func login() {
            navigator.login()
        }

        func register() {
            navigator.register()
        }

        func loadData() {
            self.mapService.queryTrackedPaths()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.currentEmail = UserDefaults(suiteName: "group.koszti.storedData")?.string(forKey: "email") ?? ""

                self.userName = UserDefaults(suiteName: "group.koszti.storedData")?.string(forKey: "name") ?? ""
                self.makeTotals()
            }
        }

        func bindPublishers() {
            accountService.isSignedInPublisher
                .sink { _ in
                } receiveValue: { [weak self] isSignedIn in
                    self?.isSignedIn = isSignedIn
                }
                .store(in: &cancellables)

            mapService.trackedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    guard let self else { return}
                    // TODO: INIT USER ELSEWHERE
//                    if track == nil {
//                        self?.accountService.initUser()
//                    }
                    self.tracks = track?.tracks ?? []
                    if !self.tracks.isEmpty {
                        self.makeTotals()
                    }
                }
                .store(in: &cancellables)
        }

        func makeTotals() {
            var total = 0.0
            var totalDate = 0.0
            for track in tracks {
                let startDate = dateFormatter.date(from: track.startDate) ?? Date()
                let endDate = dateFormatter.date(from: track.endDate) ?? Date()
                let date = startDate.distance(to: endDate)
                var list: [CLLocation] = []
                var distance = 0.0
                for index in 0..<(track.xCoords?.count ?? 0) {
                    list.append(CLLocation(latitude: track.xCoords?[index] ?? 0, longitude: track.yCoords?[index] ?? 0))
                }
                for itemDx in 1..<list.count {
                    distance += list[itemDx].distance(from: list[itemDx - 1])
                }
                total += distance
                totalDate += date
            }
            totalTime = formatter.string(from: totalDate) ?? ""
            totalDistance = total
            let totalTime = totalDate

            if isSignedIn && totalDistance > 0 {
                accountService.updateLeaderboard(time: totalTime, distance: totalDistance)
            }
        }

        func updatePasswordTap() {
            navigator.updatePassword()
        }

        func dismissButtonTap() {
            navigator.dismissScreen()
        }
    }
}
