import Combine
import GoogleMaps
@testable import PowderTrackr
import XCTest

final class RaceRunViewModelTests: XCTestCase {
    private var sut: RaceRunView.ViewModel!
    private var race: TrackedPath!
    private var closestRun: TrackedPath!

    override func setUpWithError() throws {
        super.setUp()

        race = TrackedPath(id: "race1", name: "Race 1", startDate: "2023-08-01 10:00:00", endDate: "2023-08-01 10:30:00", notes: [], xCoords: [0.0, 1.0, 2.0], yCoords: [0.0, 1.0, 2.0], tracking: false)
        closestRun = TrackedPath(id: "run1", name: "Closest Run", startDate: "2023-08-01 10:00:00", endDate: "2023-08-01 10:25:00", notes: [], xCoords: [0.0, 0.5, 1.5], yCoords: [0.0, 0.5, 1.5], tracking: false)

        sut = RaceRunView.ViewModel(closestRun: closestRun, race: race)
    }

    override func tearDownWithError() throws {
        sut = nil
        race = nil
        closestRun = nil
        super.tearDown()
    }

    func test_initFormatters_shouldInitializeDateFormatterAndTimeFormatter() {
        XCTAssertEqual(sut.dateFormatter.dateFormat, "yyyy-MM-dd HH:mm:ss")
        XCTAssertEqual(sut.formatter.allowedUnits, [.hour, .minute, .second])
    }

    func test_initTimes_shouldSetElapsedTimeAndInitializePlayer() {
        sut.initTimes()

        XCTAssertEqual(sut.elapsedTimeInString, "30m")
    }

    func test_calculateDistance_shouldReturnCorrectTotalDistance() {
        let distance = sut.calculateDistance()

        XCTAssertEqual(distance, 314_498.75250836094, accuracy: 1_000)
    }

    func test_setTotalDistanceBetweenStartAndEnd_shouldSetTotalDistanceCorrectly() {
        sut.setTotalDistanceBetweenStartAndEnd()

        XCTAssertEqual(sut.totalDistance, 314_000, accuracy: 1_000)
    }

    func test_startPlay_shouldSetPlayerStateToPlayingAndStartTimer() {
        sut.startPlay()

        XCTAssertEqual(sut.playerState, .playing)
        XCTAssertNotNil(sut.timer)
    }

    func test_pausePlay_shouldSetPlayerStateToPausedAndStopTimer() {
        sut.startPlay()
        sut.pausePlay()

        XCTAssertEqual(sut.playerState, .paused)
        XCTAssertNil(sut.timer)
    }

    func test_resumePlay_shouldSetPlayerStateToPlayingAndStartTimer() {
        sut.startPlay()
        sut.pausePlay()
        sut.resumePlay()

        XCTAssertEqual(sut.playerState, .playing)
        XCTAssertNotNil(sut.timer)
    }

    func test_stepPlayer_whenPlayerReaches100_shouldStopAndInvalidateTimer() {
        sut.player = 95
        sut.playSpeed = 5

        sut.stepPlayer()

        XCTAssertEqual(sut.player, 100)
        XCTAssertEqual(sut.playerState, .stopped)
        XCTAssertNil(sut.timer)
    }

    func test_setSpeed_shouldChangePlaybackSpeed() {
        XCTAssertEqual(sut.playBackSpeed, .simple)

        sut.setSpeed()

        XCTAssertEqual(sut.playBackSpeed, .double)
        XCTAssertEqual(sut.playSpeed, 2)

        sut.setSpeed()

        XCTAssertEqual(sut.playBackSpeed, .triple)
        XCTAssertEqual(sut.playSpeed, 5)

        sut.setSpeed()

        XCTAssertEqual(sut.playBackSpeed, .simple)
        XCTAssertEqual(sut.playSpeed, 1)
    }

    func test_playButtonTap_shouldTogglePlayerStateCorrectly() {
        sut.playButtonTap()

        XCTAssertEqual(sut.playerState, .playing)

        sut.playButtonTap()

        XCTAssertEqual(sut.playerState, .paused)

        sut.playButtonTap()

        XCTAssertEqual(sut.playerState, .playing)
    }

    func test_calculateDistanceFromStartingPoint_shouldUpdatePlayerAndOpponentPositions() {
        sut.calculateDistanceFromStartingPoint(index: 2)

        XCTAssertEqual(sut.playerPosition, 100)
        XCTAssertEqual(sut.opponentPosition, 75)
        XCTAssertEqual(sut.currentDistanceToFinish, .zero)
    }
}
