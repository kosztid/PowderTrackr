import SwiftUI

extension RaceRunView {
    enum PlayerState {
        case playing
        case stopped
        case paused
    }
    final class ViewModel: ObservableObject {
        var timer: Timer?
        @Published var player = -1
        @Published var playerState = PlayerState.stopped
        @Published var race: String

        init(race: String) {
            self.race = race
        }
        func startPlay() {
            withAnimation {
                player = 0
                playerState = .playing
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stepPlayer), userInfo: nil, repeats: true)
        }

        @objc func stepPlayer() {
            if player == 7 {
                self.timer?.invalidate()
                self.timer = nil
                playerState = .stopped
            }
            withAnimation {
                player += 1
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
