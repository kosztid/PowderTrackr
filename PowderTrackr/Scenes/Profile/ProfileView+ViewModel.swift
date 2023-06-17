import Amplify
import Combine
import GoogleMaps
import SwiftUI

extension ProfileView {
    final class ViewModel: ObservableObject {
        @Published var isSignedIn = false
        @Published var currentUser: AuthUser?
        @Published var currentEmail: String?
        @Published var tracks: [TrackedPath] = []
        @Published var totalDistance: Double = 0.0
        @Published var totalTime: String = ""

        let dateFormatter = DateFormatter()
        let formatter = DateComponentsFormatter()
        private var cancellables: Set<AnyCancellable> = []
        private let navigator: ProfileViewNavigatorProtocol
        private let accountService: AccountServiceProtocol

        func logout() {
            Task {
                await accountService.signOut()
                await accountService.queryTrackedPaths()
            }
        }

        func login() {
            navigator.login()
        }

        func register() {
            navigator.register()
        }

        func loadData() {
            Task {
                await accountService.getUser()
                await accountService.queryTrackedPaths()
            }
        }

        func bindPublishers() {
            accountService.isSignedInPublisher
                .sink { _ in
                } receiveValue: { [weak self] isSignedIn in
                    self?.isSignedIn = isSignedIn
                }
                .store(in: &cancellables)

            accountService.userPublisher
                .sink { _ in
                } receiveValue: { [weak self] user in
                    self?.currentUser = user
                }
                .store(in: &cancellables)

            accountService.emailPublisher
                .sink { _ in
                } receiveValue: { [weak self] email in
                    self?.currentEmail = email
                }
                .store(in: &cancellables)

            accountService.trackedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    self?.tracks = track?.tracks ?? []
                    self?.makeTotals()
                }
                .store(in: &cancellables)
        }

        init(
            navigator: ProfileViewNavigatorProtocol,
            accountService: AccountServiceProtocol
        ) {
            self.navigator = navigator
            self.accountService = accountService
            bindPublishers()

            Task {
                await accountService.getUser()
            }

            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .abbreviated
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
        }
    }
}
