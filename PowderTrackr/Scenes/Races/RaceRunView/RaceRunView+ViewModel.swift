import GoogleMaps
import SwiftUI

extension RaceRunView {
    enum PlayerState {
        case playing
        case stopped
        case paused
    }
    enum PlayBackSpeed {
        case simple
        case double
        case triple
    }
    final class ViewModel: ObservableObject {
        var timer: Timer?
        var totalDistance = 0.0
        @Published var playSpeed = 1
        var playBackSpeed = PlayBackSpeed.simple
        @Published var player = -1
        @Published var playerPosition = 0 // %
        @Published var opponentPosition = 0 // %
        @Published var playerState = PlayerState.stopped
        @Published var race: TrackedPath
        @Published var closestRun: TrackedPath?
        @Published var elapsedTime = 0.0
        @Published var elapsedTimeInString: String = ""
        @Published var arrayBreakPoint = 0
        @Published var currentArrayIndex = 0
        @Published var currentDistanceToFinish = 0.0
        let dateFormatter = DateFormatter()
        let formatter = DateComponentsFormatter()

//        private let navigator: RaceRunViewNavigatorProtocol

        init(
//            navigator: RaceRunViewNavigatorProtocol,
            closestRun: TrackedPath?,
            race: TrackedPath
        ) {
            self.race = race
            self.closestRun = closestRun
            initFormatters()
            initTimes()
            setTotalDistanceBetweenStartAndEnd()
//            self.navigator = navigator
            print(closestRun?.id)
            print(race.id)
        }

        func initFormatters() {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .abbreviated
        }

        func initTimes() {
            let startDate = dateFormatter.date(from: race.startDate) ?? Date()
            let endDate = dateFormatter.date(from: race.endDate) ?? Date()
            elapsedTime = startDate.distance(to: endDate)
            elapsedTimeInString = formatter.string(from: elapsedTime) ?? ""
            initRacePlayer()
        }

        func initRacePlayer() {
            arrayBreakPoint = Int((Double(race.xCoords?.count ?? .zero) / 100.0).rounded())
        }


        func calculateDistanceFromStartingPoint(index: Int) {
            var distance = 0.0
            var list: [CLLocation] = []
            list.append(CLLocation(latitude: race.xCoords?.first ?? 0.0, longitude: race.yCoords?.first ?? 0.0))
            list.append(CLLocation(latitude: race.xCoords?[index] ?? 0.0, longitude: race.yCoords?[index] ?? 0.0))
            for itemDx in 1..<list.count {
                distance += list[itemDx].distance(from: list[itemDx - 1])
            }

            if let opponentRun = closestRun {
                var opponentDistance = 0.0
                var opponentList: [CLLocation] = []
                opponentList.append(CLLocation(latitude: opponentRun.xCoords?.first ?? 0.0, longitude: opponentRun.yCoords?.first ?? 0.0))
                opponentList.append(CLLocation(latitude: opponentRun.xCoords?[index] ?? 0.0, longitude: opponentRun.yCoords?[index] ?? 0.0))
                for itemDx in 1..<opponentList.count {
                    opponentDistance += opponentList[itemDx].distance(from: opponentList[itemDx - 1])
                }
                opponentPosition = Int((opponentDistance / totalDistance * 100).rounded())
            }
            currentDistanceToFinish = totalDistance - distance
            playerPosition = Int((distance / totalDistance * 100).rounded())

        }

        func setTotalDistanceBetweenStartAndEnd() {
            var distance = 0.0
            var list: [CLLocation] = []
            list.append(CLLocation(latitude: race.xCoords?.first ?? 0.0, longitude: race.yCoords?.first ?? 0.0))
            list.append(CLLocation(latitude: race.xCoords?.last ?? 0.0, longitude: race.yCoords?.last ?? 0.0))
            for itemDx in 1..<list.count {
                distance += list[itemDx].distance(from: list[itemDx - 1])
            }
            totalDistance = distance
        }

        func startPlay() {
            withAnimation {
                player = 0
                playerState = .playing
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stepPlayer), userInfo: nil, repeats: true)
        }

        func setSpeed() {
            switch playBackSpeed {
            case .simple:
                playBackSpeed = .double
                playSpeed = 2
            case .double:
                playBackSpeed = .triple
                playSpeed = 5
            case .triple:
                playBackSpeed = .simple
                playSpeed = 1
            }
            self.timer?.invalidate()
            self.timer = nil
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stepPlayer), userInfo: nil, repeats: true)
        }

        @objc func stepPlayer() {
            if player >= 100 {
                self.timer?.invalidate()
                self.timer = nil
                playerState = .stopped
                return
            }
            withAnimation {
                player += playSpeed
                if (race.xCoords?.count ?? 0) >= (currentArrayIndex + playSpeed * arrayBreakPoint) {
                    currentArrayIndex += playSpeed * arrayBreakPoint
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                    playerState = .stopped
                    return
                }
            }
        }

        func pausePlay() {
            self.timer?.invalidate()
            self.timer = nil
            withAnimation {
                playerState = .paused
            }
        }

        func resumePlay() {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stepPlayer), userInfo: nil, repeats: true)
            withAnimation {
                playerState = .playing
            }
        }

        func playButtonTap() {
            switch playerState {
            case .playing:
                pausePlay()
            case .stopped:
                startPlay()
            case .paused:
                resumePlay()
            }
        }
    }
}
