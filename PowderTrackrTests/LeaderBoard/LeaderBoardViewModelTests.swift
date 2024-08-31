import Combine
@testable import PowderTrackr
import XCTest

    final class LeaderBoardViewModelTests: XCTestCase {
        private var sut: LeaderBoardView.ViewModel!
        private var statServiceMock: StatisticsServiceProtocolMock!
        private var cancellables: Set<AnyCancellable>!

        override func setUpWithError() throws { /* 1 */
            super.setUp()
            cancellables = Set<AnyCancellable>()
            statServiceMock = StatisticsServiceProtocolMock()

            statServiceMock.underlyingLeaderboardPublisher = CurrentValueSubject<[LeaderBoard], Never>([
                LeaderBoard(id: "1", name: "User A", distance: 300.0, totalTimeInSeconds: 4_000),
                LeaderBoard(id: "2", name: "User B", distance: 200.0, totalTimeInSeconds: 3_000),
                LeaderBoard(id: "3", name: "User C", distance: 400.0, totalTimeInSeconds: 2_000)
            ]).eraseToAnyPublisher()

            sut = LeaderBoardView.ViewModel(statservice: statServiceMock)
        }

        override func tearDownWithError() throws { /* 2 */
            sut = nil
            statServiceMock = nil
            cancellables = nil
            super.tearDown()
        }

        func test_onAppear_whenInvoked_shouldLoadLeaderboard() { /* 3 */
            sut.onAppear()

            XCTAssertTrue(statServiceMock.loadLeaderboardCalled)
        }

        func test_leaderBoardList_whenTabStateIsDistance_shouldReturnSortedByDistance() {
            sut.tabState = .distance

            XCTAssertEqual(sut.leaderBoardList.map { $0.name }, ["User C", "User A", "User B"])
        }

        func test_leaderBoardList_whenTabStateIsTime_shouldReturnSortedByTime() {
            sut.tabState = .time

            XCTAssertEqual(sut.leaderBoardList.map { $0.name }, ["User A", "User B", "User C"])
        }
    }
