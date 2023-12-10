import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import Combine
import UIKit

public protocol StatisticsServiceProtocol: AnyObject {
    var leaderboardPublisher: AnyPublisher<[LeaderBoard], Never> { get }

    func loadLeaderboard() async
}

final class StatisticsService {
    private let leaderboard: CurrentValueSubject<[LeaderBoard], Never> = .init([])
}

extension StatisticsService: StatisticsServiceProtocol {
    var leaderboardPublisher: AnyPublisher<[LeaderBoard], Never> {
        leaderboard
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func loadLeaderboard() {
        DefaultAPI.leaderBoardsGet { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                self.leaderboard.send(data ?? [])
            }
        }
    }
}
