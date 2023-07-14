import Amplify
import Combine
import UIKit

public protocol MapServiceProtocol: AnyObject {
    var trackingPublisher: AnyPublisher<TrackedPath?, Never> { get }
    var trackedPathPublisher: AnyPublisher<TrackedPathModel?, Never> { get }
    var sharedPathPublisher: AnyPublisher<TrackedPathModel?, Never> { get }

    func updateTrackedPath(_ trackedPath: TrackedPath) async
    func updateTrack(_ trackedPath: TrackedPath) async
    func shareTrack(_ trackedPath: TrackedPath, _ friend: String) async
    func removeTrackedPath(_ trackedPath: TrackedPath) async
    func queryTrackedPaths() async
    func querySharedPaths() async
    func sendCurrentlyTracked(_ trackedPath: TrackedPath) async
}

final class MapService {
    private let tracking: CurrentValueSubject<TrackedPath?, Never> = .init(nil)
    private let trackedPathModel: CurrentValueSubject<TrackedPathModel?, Never> = .init(nil)
    private let sharedPathModel: CurrentValueSubject<TrackedPathModel?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = []
}

extension MapService: MapServiceProtocol {
    func sendCurrentlyTracked(_ trackedPath: TrackedPath) async {
        tracking.send(trackedPath)
    }

    var trackingPublisher: AnyPublisher<TrackedPath?, Never> {
        tracking
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var trackedPathPublisher: AnyPublisher<TrackedPathModel?, Never> {
        trackedPathModel
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var sharedPathPublisher: AnyPublisher<TrackedPathModel?, Never> {
        sharedPathModel
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func shareTrack(_ trackedPath: TrackedPath, _ friend: String) async {
    }

    func queryTrackedPaths() async {
        do {
            let queryResult = try await Amplify.API.query(request: .list(UserTrackedPaths.self))

            let user = try await Amplify.Auth.getCurrentUser()

            let result = try queryResult.get().elements.map { model in
                TrackedPathModel(from: model)
            }

            let currentPaths = result.first { $0.id == user.userId }

            trackedPathModel.send(currentPaths)
        } catch {
            print("Can not retrieve queryTrackedPaths : error \(error)")
        }
    }

    func querySharedPaths() async {
        do {
            let queryResult = try await Amplify.API.query(request: .list(UserTrackedPaths.self))

            let user = try await Amplify.Auth.getCurrentUser()

            let result = try queryResult.get().elements.map { model in
                TrackedPathModel(from: model)
            }
//            let sharedPaths = result.first { $0.shared.contains(user.username) }

//            sharedPathModel.send(sharedPaths)
        } catch {
            print("Can not retrieve queryTrackedPaths : error \(error)")
        }
    }

    func updateTrackedPath(_ trackedPath: TrackedPath) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            let tracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(from: item)
            }

            var tracks = tracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            tracks?.append(trackedPath)

            let trackModel = TrackedPathModel(id: user.userId, tracks: tracks)
            guard let data = trackModel.data else { return }
            _ = try await Amplify.API.mutate(request: .update(data))

            await queryTrackedPaths()
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func updateTrack(_ trackedPath: TrackedPath) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            let tracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(from: item)
            }

            var tracks = tracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks
            let id = tracks?.firstIndex { $0.id == trackedPath.id } ?? 0
            tracks?[id] = trackedPath

            let trackModel = TrackedPathModel(id: user.userId, tracks: tracks)
            guard let data = trackModel.data else { return }
            _ = try await Amplify.API.mutate(request: .update(data))

            await queryTrackedPaths()
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func removeTrackedPath(_ trackedPath: TrackedPath) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            let tracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(from: item)
            }

            var tracks = tracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            tracks?.removeAll { $0.id == trackedPath.id }

            let trackModel = TrackedPathModel(id: user.userId, tracks: tracks)
            guard let data = trackModel.data else { return }
            _ = try await Amplify.API.mutate(request: .update(data))

            await queryTrackedPaths()
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }
}
