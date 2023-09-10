import Combine
import GoogleMaps
import SwiftUI

extension TrackListView {
    final class ViewModel: ObservableObject {
        private var cancellables: Set<AnyCancellable> = []

        private let friendService: FriendServiceProtocol
        private let mapService: MapServiceProtocol
        private let accountService: AccountServiceProtocol

        @Published var friendList: Friendlist?
        @Published var tracks: [TrackedPath] = []
        @Published var sharedTracks: [TrackedPath] = []
        @Published var signedIn = false
        @Published var trackToShare: TrackedPath?

        init(
            mapService: MapServiceProtocol,
            accountService: AccountServiceProtocol,
            friendService: FriendServiceProtocol
        ) {
            self.mapService = mapService
            self.accountService = accountService
            self.friendService = friendService

            mapService.trackedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    self?.tracks = track?.tracks ?? []
                }
                .store(in: &cancellables)

            mapService.sharedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    self?.sharedTracks = track?.tracks ?? []
                }
                .store(in: &cancellables)

            accountService.isSignedInPublisher
                .sink(receiveValue: { [weak self] value in
                    self?.signedIn = value
                    if !value {
                        self?.tracks = []
                    }
                })
                .store(in: &cancellables)

            friendService.friendListPublisher
                .sink { _ in
                } receiveValue: { [weak self] friendList in
                    self?.friendList = friendList
                }
                .store(in: &cancellables)

            Task {
                await mapService.queryTrackedPaths()
                await friendService.queryFriends()
            }
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
            Task {
                await mapService.queryTrackedPaths()
                await mapService.querySharedPaths()
            }
        }

        func removeTrack(_ trackedPath: TrackedPath) {
            Task {
                await mapService.removeTrackedPath(trackedPath)
            }
        }

        func updateTrack(_ trackedPath: TrackedPath, shared: Bool) {
            Task {
                await mapService.updateTrack(trackedPath, shared)
            }
        }

        func shareTrack(_ trackedPath: TrackedPath) {
            trackToShare = trackedPath
        }


        func addNote(_ note: String, _ trackedPath: TrackedPath) {
            Task {
                var newTrack = trackedPath
                newTrack.notes?.append(note)
                await mapService.updateTrack(newTrack, false)
            }
        }

        func share(with friend: Friend) {
            guard let trackToShare else { return }
            Task {
                await mapService.shareTrack(trackToShare, friend.id)
            }
        }

        func removeSharedTrack(_ trackedPath: TrackedPath) {
            Task {
                await mapService.removeSharedTrackedPath(trackedPath)
            }
        }
    }
}
