import Combine
import SwiftUI

extension LeaderBoardView {
    struct LeaderBoardEntity: Identifiable {
        let id = UUID().uuidString
        let name: String
        let distance: Double
        let totalTimeInSeconds: Double
    }

    enum TabState {
        case distance
        case time
    }
    
    final class ViewModel: ObservableObject {
        @Published var leaderBoardItems: [LeaderBoard] = []
        @Published var tabState: TabState = .distance

        var leaderBoardForDistance: [LeaderBoard] { leaderBoardItems.sorted { $0.distance > $1.distance } }
        var leaderBoardForTime: [LeaderBoard] { leaderBoardItems.sorted { $0.totalTimeInSeconds > $1.totalTimeInSeconds } }

        var leaderBoardList: [LeaderBoard] { tabState == .distance ? leaderBoardForDistance : leaderBoardForTime}

        private var cancellables: Set<AnyCancellable> = []
        private let statService: StatisticsServiceProtocol

        init(statservice: StatisticsServiceProtocol) {
            self.statService = statservice

            statservice.leaderboardPublisher
                .sink { _ in
                } receiveValue: { [weak self] list in
                    self?.leaderBoardItems = list
                    print("lbitem", self?.leaderBoardItems)
                }
                .store(in: &cancellables)
        }

        func onAppear() {
            Task {
                await statService.loadLeaderboard()
                print("onappear")
            }
        }
    }
}
