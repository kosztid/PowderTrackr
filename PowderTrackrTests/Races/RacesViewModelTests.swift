import AWSCognitoIdentityProvider
import Combine
import GoogleMaps
@testable import PowderTrackr
import XCTest

final class RacesViewModelTests: XCTestCase {
    private var sut: RacesView.ViewModel!
    private var mapServiceMock: MapServiceProtocolMock!
    private var friendServiceMock: FriendServiceProtocolMock!
    private var accountServiceMock: AccountServiceProtocolMock!
    private var navigatorMock: RacesViewNavigatorProtocolMock!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        mapServiceMock = MapServiceProtocolMock()
        friendServiceMock = FriendServiceProtocolMock()
        accountServiceMock = AccountServiceProtocolMock()
        navigatorMock = RacesViewNavigatorProtocolMock()

        accountServiceMock.underlyingUserPublisher = CurrentValueSubject<AWSCognitoIdentityUser?, Never>(nil).eraseToAnyPublisher()
        accountServiceMock.isSignedInPublisher = CurrentValueSubject<Bool, Never>(true).eraseToAnyPublisher()
        friendServiceMock.underlyingFriendListPublisher = CurrentValueSubject<Friendlist?, Never>(nil).eraseToAnyPublisher()
        mapServiceMock.underlyingRacesPublisher = CurrentValueSubject<[Race], Never>([
            Race(id: "1", name: "Test Race 1", date: "2023-08-01", shortestTime: -1, shortestDistance: -1, tracks: []),
            Race(id: "2", name: "Test Race 2", date: "2023-08-02", shortestTime: 500, shortestDistance: 200, tracks: [])
        ]).eraseToAnyPublisher()

        sut = RacesView.ViewModel(
            mapService: mapServiceMock,
            friendService: friendServiceMock,
            accountService: accountServiceMock,
            navigator: navigatorMock,
            inputModel: RacesView.InputModel(navigateToAccount: {})
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        mapServiceMock = nil
        friendServiceMock = nil
        accountServiceMock = nil
        navigatorMock = nil
        cancellables = nil
        super.tearDown()
    }

    func test_initBindings_whenViewModelInitialized_shouldBindPublishers() {
        XCTAssertEqual(sut.races.count, 2, "Should initialize with the races provided by the map service")
        XCTAssertEqual(sut.signedIn, true, "Should initialize with the signed-in status provided by the account service")
    }

    func test_navigateToMyRuns_whenCalled_shouldNavigateToRaceRuns() {
        let race = Race(id: "1", name: "Test Race 1", date: "2023-08-01", shortestTime: -1, shortestDistance: -1, tracks: [])
        sut.navigateToMyRuns(race: race)

        XCTAssertTrue(navigatorMock.navigateToRaceRunsRaceCalled, "navigateToRaceRuns should be called on the navigator")
    }

    func test_share_whenCalled_shouldCallShareRaceOnMapService() {
        let race = Race(id: "1", name: "Test Race 1", date: "2023-08-01", shortestTime: -1, shortestDistance: -1, tracks: [])
        sut.raceToShare = race
        let friend = Friend(id: "friend1", name: "Friend One", isTracking: true)

        sut.share(with: friend)

        XCTAssertTrue(mapServiceMock.shareRaceCalled, "shareRace should be called on the map service")
    }

    func test_refreshRaces_whenCalled_shouldQueryRacesFromMapService() {
        sut.refreshRaces()

        XCTAssertTrue(mapServiceMock.queryRacesCalled, "queryRaces should be called on the map service")
    }

    func test_deleteRace_whenCalled_shouldRemoveRaceAndCallDeleteOnMapService() {
        let race = Race(id: "1", name: "Test Race 1", date: "2023-08-01", shortestTime: -1, shortestDistance: -1, tracks: [])
        sut.races = [race]
        sut.raceToDelete = "1"

        sut.deleteRace()

        XCTAssertTrue(mapServiceMock.deleteRaceCalled, "deleteRace should be called on the map service")
        XCTAssertEqual(sut.races.count, 0, "The race should be removed from the races list")
    }

    func test_updateShortestRun_whenCalled_shouldUpdateShortestTimesAndDistances() {
        var race = Race(id: "1", name: "Test Race 1", date: "2023-08-01", shortestTime: -1, shortestDistance: -1, tracks: [
            TrackedPath(id: "1", name: "Run 1", startDate: "2023-08-01 10:00:00", endDate: "2023-08-01 10:30:00", notes: [], xCoords: [0, 1], yCoords: [0, 1], tracking: false)
        ])
        sut.races = [race]

        sut.updateShortestRun()

        XCTAssertTrue(mapServiceMock.updateRaceCalled, "updateRace should be called on the map service")
    }
}
