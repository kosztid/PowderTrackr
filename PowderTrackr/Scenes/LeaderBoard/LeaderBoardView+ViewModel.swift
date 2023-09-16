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
        @Published var leaderBoardItems: [LeaderBoardEntity]
        @Published var tabState: TabState = .distance

        var leaderBoardForDistance: [LeaderBoardEntity] { leaderBoardItems.sorted { $0.distance > $1.distance } }
        var leaderBoardForTime: [LeaderBoardEntity] { leaderBoardItems.sorted { $0.totalTimeInSeconds > $1.totalTimeInSeconds } }

        var leaderBoardList: [LeaderBoardEntity] { tabState == .distance ? leaderBoardForDistance : leaderBoardForTime}

        init() {
            self.leaderBoardItems = [
                .init(name: "Dominik", distance: 1012, totalTimeInSeconds: 360),
                .init(name: "Panka", distance: 1101.123, totalTimeInSeconds: 370),
                .init(name: "Pank", distance: 1601.123, totalTimeInSeconds: 420),
                .init(name: "Domi", distance: 1201.123, totalTimeInSeconds: 300)
            ]
        }

    }
}
