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

    func loadLeaderboard() async {
        do {
            let queryResult = try await Amplify.API.query(request: .list(LeaderBoard.self))

            let result = try queryResult.get().elements.map { item in
                LeaderBoard(
                    name: item.name,
                    distance: item.distance,
                    totalTimeInSeconds: item.totalTimeInSeconds
                )
            }
            DefaultAPI.leaderBoardsGet { data, error in
                if let error = error {
                        print("Error: \(error)")
                    } else {
                        print("Success! Data: \(data)")
                        self.leaderboard.send(data ?? [])
                    }
            }
        } catch {
            print("Can not retrieve leaderboard : error \(error)")
        }
    }
}
