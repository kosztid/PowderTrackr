import Combine
import GoogleMaps
import SwiftUI

extension TrackListView {
    struct InputModel {
        let navigateToAccount: () -> Void
    }
    
    final class ViewModel: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []

        private let friendService: FriendServiceProtocol
        private let mapService: MapServiceProtocol
        private let accountService: AccountServiceProtocol
        
        let model: InputModel

        @Published var friendList: Friendlist?
        @Published var tracks: [TrackedPath] = []
        @Published var sharedTracks: [TrackedPath] = []
        @Published var signedIn = false
        @Published var trackToShare: TrackedPath?

        init(
            mapService: MapServiceProtocol,
            accountService: AccountServiceProtocol,
            friendService: FriendServiceProtocol,
            inputModel: InputModel
        ) {
            self.mapService = mapService
            self.accountService = accountService
            self.friendService = friendService
            self.model = inputModel

            mapService.trackedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    guard let self else { return }
                    if self.signedIn {
                        self.tracks = track?.tracks ?? []
                    } else {
                        self.tracks = []
                    }
                }
                .store(in: &cancellables)

            mapService.sharedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    guard let self else { return }
                    if self.signedIn {
                        self.sharedTracks = track?.tracks ?? []
                    } else {
                        self.sharedTracks = []
                    }
                }
                .store(in: &cancellables)

            accountService.isSignedInPublisher
                .sink(receiveValue: { [weak self] value in
                    guard let self else { return }
                    self.signedIn = value
                    if !value {
                        self.tracks = []
                        self.sharedTracks = []
                    }
                })
                .store(in: &cancellables)

            friendService.friendListPublisher
                .sink { _ in
                } receiveValue: { [weak self] friendList in
                    self?.friendList = friendList
                }
                .store(in: &cancellables)

            mapService.queryTrackedPaths(nil)
            friendService.queryFriends()
        }

        func calculateDistance(track: TrackedPath) -> Double {
            var list: [CLLocation] = []
            var distance = 0.0
            for index in 0..<(track.xCoords?.count ?? 0) {
                list.append(CLLocation(latitude: track.xCoords?[index] ?? 0, longitude: track.yCoords?[index] ?? 0))
            }
            for itemDx in 1..<list.count {
                distance += list[itemDx].distance(from: list[itemDx - 1])
            }
            return distance
        }

        func onAppear() {
            mapService.queryTrackedPaths()
            mapService.querySharedPaths()
        }

        func removeTrack(_ trackedPath: TrackedPath) {
            mapService.removeTrackedPath(trackedPath)
        }

        func updateTrack(_ trackedPath: TrackedPath, shared: Bool) {
            mapService.updateTrack(trackedPath, shared)
        }

        func shareTrack(_ trackedPath: TrackedPath) {
            trackToShare = trackedPath
        }

        func addNote(_ note: String, _ trackedPath: TrackedPath) {var newTrack = trackedPath
            newTrack.notes?.append(note)
            mapService.updateTrack(newTrack, false)
        }

        func share(with friend: Friend) {
            guard let trackToShare else { return }
            mapService.shareTrack(trackToShare, friend.id)
        }

        func removeSharedTrack(_ trackedPath: TrackedPath) {
            mapService.removeSharedTrackedPath(trackedPath)
        }
    }
}
