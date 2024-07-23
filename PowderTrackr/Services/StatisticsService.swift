import Combine
import UIKit

// sourcery: mock
public protocol StatisticsServiceProtocol: AnyObject {
    var leaderboardPublisher: AnyPublisher<[LeaderBoard], Never> { get }
    var networkErrorPublisher: AnyPublisher<ToastModel?, Never> { get }

    func loadLeaderboard() async
}

final class StatisticsService {
    private let leaderboard: CurrentValueSubject<[LeaderBoard], Never> = .init([])
    private let networkError: CurrentValueSubject<ToastModel?, Never> = .init(nil)
}

extension StatisticsService: StatisticsServiceProtocol {
    var networkErrorPublisher: AnyPublisher<ToastModel?, Never> {
        networkError
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var leaderboardPublisher: AnyPublisher<[LeaderBoard], Never> {
        leaderboard
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func loadLeaderboard() {
        DefaultAPI.leaderBoardsGet { data, error in
            if let error = error {
                self.networkError.send(.init(title: "An issue occured while loading leaderboard data", type: .error))
                print("Error: \(error)")
            } else {
                self.leaderboard.send(data ?? [])
            }
        }
    }
}
