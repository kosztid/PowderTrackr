import Combine
import GoogleMaps
@testable import PowderTrackr
import XCTest

final class MyRunsViewModelTests: XCTestCase {
    private var sut: MyRunsView.ViewModel!
    private var accountServiceMock: AccountServiceProtocolMock!
    private var race: Race!

    override func setUpWithError() throws {
        super.setUp()
        accountServiceMock = AccountServiceProtocolMock()
        race = Race(
            id: "race1",
            name: "Race 1",
            date: "2023-08-01",
            shortestTime: 1_800,
            shortestDistance: 5.0,
            tracks: [
                TrackedPath(id: "track1", name: "Track 1", startDate: "2023-08-01 10:00:00", endDate: "2023-08-01 10:30:00", notes: ["user1"], xCoords: [0.0, 1.0, 2.0], yCoords: [0.0, 1.0, 2.0], tracking: false),
                TrackedPath(id: "track2", name: "Track 2", startDate: "2023-08-01 10:00:00", endDate: "2023-08-01 10:20:00", notes: ["user2"], xCoords: [0.0, 0.5, 1.0], yCoords: [0.0, 0.5, 1.0], tracking: false)
            ]
        )

        sut = MyRunsView.ViewModel(race: race, accountService: accountServiceMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        accountServiceMock = nil
        race = nil
        super.tearDown()
    }

    func test_calculateDistance_shouldReturnCorrectDistance() {
        let distance = sut.calculateDistance(race.tracks!.first!)

        XCTAssertEqual(distance, 314_498.75250836094, accuracy: 1_000)
    }
}
