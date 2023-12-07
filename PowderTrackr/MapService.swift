import Amplify
import Combine
import GoogleMaps
import UIKit

public protocol MapServiceProtocol: AnyObject {
    var trackingPublisher: AnyPublisher<TrackedPath?, Never> { get }
    var trackedPathPublisher: AnyPublisher<TrackedPathModel?, Never> { get }
    var sharedPathPublisher: AnyPublisher<TrackedPathModel?, Never> { get }
    var raceCreationStatePublisher: AnyPublisher<RaceCreationState, Never> { get }
    var racesPublisher: AnyPublisher<[Race], Never> { get }

    func updateTrackedPath(_ trackedPath: TrackedPath) async
    func updateTrack(_ trackedPath: TrackedPath, _ shared: Bool) async
    func shareTrack(_ trackedPath: TrackedPath, _ friend: String) async
    func removeTrackedPath(_ trackedPath: TrackedPath) async
    func removeSharedTrackedPath(_ trackedPath: TrackedPath) async
    func queryTrackedPaths() async
    func querySharedPaths() async
    func sendCurrentlyTracked(_ trackedPath: TrackedPath) async
    func changeRaceCreationState(_ raceCreationState: RaceCreationState)
    func createRace(_ markers: [GMSMarker], _ name: String) async
    func queryRaces() async
    func sendRaceRun(_ run: TrackedPath, _ raceId: String) async
    func updateRace(_ race: Race, _ newRace: Race) async
    func shareRace(_ friend: String, _ race: Race) async
    func deleteRace(_ race: Race) async
}

final class MapService {
    private let tracking: CurrentValueSubject<TrackedPath?, Never> = .init(nil)
    private let trackedPathModel: CurrentValueSubject<TrackedPathModel?, Never> = .init(nil)
    private let sharedPathModel: CurrentValueSubject<TrackedPathModel?, Never> = .init(nil)
    private let raceCreationState: CurrentValueSubject<RaceCreationState, Never> = .init(.not)
    private let races: CurrentValueSubject<[Race], Never> = .init([])
    private var cancellables: Set<AnyCancellable> = []
}

extension MapService: MapServiceProtocol {
    var raceCreationStatePublisher: AnyPublisher<RaceCreationState, Never> {
        raceCreationState
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

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

    var racesPublisher: AnyPublisher<[Race], Never> {
        races
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func shareTrack(_ trackedPath: TrackedPath, _ friend: String) async {
        do {
            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            let result = try tracksQueryResults.get().elements.map { model in
                TrackedPathModel(id: model.id, tracks: model.sharedTracks)
            }

            let resultTracks = try tracksQueryResults.get().elements.map { model in
                TrackedPathModel(id: model.id, tracks: model.tracks)
            }

            let model = result.first { item in
                item.id == friend
            }

            let resultModel = resultTracks.first { item in
                item.id == friend
            }

            model?.tracks?.append(trackedPath)

            let newData = UserTrackedPaths(id: model?.id ?? "", tracks: resultModel?.tracks, sharedTracks: model?.tracks)

            _ = try await Amplify.API.mutate(request: .update(newData))
        } catch let error as APIError {
            print("Failed to shareTrack: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func queryTrackedPaths() async {
        do {
            let queryResult = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            

            let user = try await Amplify.Auth.getCurrentUser()

            let result = try queryResult.get().elements.map { model in
                TrackedPathModel(from: model)
            }

            let currentPaths = result.first { $0.id == user.userId }
          //  print(currentPaths?.tracks)
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
                TrackedPathModel(id: model.id, tracks: model.sharedTracks)
            }
            let sharedPaths = result.first { $0.id == user.userId }

            sharedPathModel.send(sharedPaths)
        } catch {
            print("Can not retrieve querySharedPaths : error \(error)")
        }
    }

    func updateTrackedPath(_ trackedPath: TrackedPath) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            let tracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(from: item)
            }
            let sharedTracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                return TrackedPathModel(id: item.id, tracks: item.sharedTracks)
            }

            var tracks = tracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            var sharedTracks = sharedTracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            tracks?.append(trackedPath)

            let data = UserTrackedPaths(id: user.userId, tracks: tracks, sharedTracks: sharedTracks)
            _ = try await Amplify.API.mutate(request: .update(data))

            await queryTrackedPaths()
        } catch let error as APIError {
            print("Failed to updateTrackedPath: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func updateTrack(_ trackedPath: TrackedPath, _ shared: Bool) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))

            let sharedTracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                return TrackedPathModel(id: item.id, tracks: item.sharedTracks)
            }

            let tracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(from: item)
            }

            var tracks = tracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            var sharedTracks = sharedTracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            if shared {
                let id = sharedTracks?.firstIndex { $0.id == trackedPath.id } ?? 0
                sharedTracks?[id] = trackedPath
            } else {
                let id = tracks?.firstIndex { $0.id == trackedPath.id } ?? 0
                tracks?[id] = trackedPath
            }

            let data = UserTrackedPaths(id: user.userId, tracks: tracks, sharedTracks: sharedTracks)
            _ = try await Amplify.API.mutate(request: .update(data))

            if shared {
                await querySharedPaths()
            } else {
                await queryTrackedPaths()
            }
        } catch let error as APIError {
            print("Failed to updateTrack: \(error)")
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
            print("Failed to removeTrackedPath: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func removeSharedTrackedPath(_ trackedPath: TrackedPath) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()

            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            let tracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(from: item)
            }

            let sharedTracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(id: item.id, tracks: item.sharedTracks)
            }

            var tracks = tracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            var sharedTracks = sharedTracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            sharedTracks?.removeAll { $0.id == trackedPath.id }

            let newData = UserTrackedPaths(id: user.userId, tracks: tracks, sharedTracks: sharedTracks)

            _ = try await Amplify.API.mutate(request: .update(newData))

            await querySharedPaths()
        } catch let error as APIError {
            print("Failed to removeSharedTrackedPath: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func changeRaceCreationState(_ raceCreationState: RaceCreationState) {
        self.raceCreationState.send(raceCreationState)
    }

    func createRace(_ markers: [GMSMarker], _ name: String) async {
        print(markers, name)
        raceCreationState.send(.not)
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let xCoords: [Double]? = markers.map { $0.position.latitude }
            let yCoords: [Double]? = markers.map { $0.position.longitude }
            let Race = Race(name: name, date: dateFormatter.string(from: Date()), shortestTime: 0.0, shortestDistance: 0.0, xCoords: xCoords ?? [], yCoords: yCoords ?? [], tracks: [], participants: [user.userId])


            _ = try await Amplify.API.mutate(request: .create(Race))
            await queryRaces()
        } catch let error as APIError {
            print("Failed to createRace: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func deleteRace(_ race: Race) async {
        do {
            _ = try await Amplify.API.mutate(request: .delete(race))
            await queryRaces()
        } catch {
            print("Can not retrieve deleteRace : error \(error)")
        }
    }

    func queryRaces() async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let queryResult = try await Amplify.API.query(request: .list(Race.self))

            let result = try queryResult.get().elements

            let filteredResult = result.filter { race in
                guard let participants = race.participants else { return false }
                if participants.contains(user.userId) {
                    return true
                } else {
                    return false
                }
            }
            races.send(filteredResult)
        } catch {
            print("Can not retrieve queryRaces : error \(error)")
        }
    }

    func updateRace(_ race: Race, _ newRace: Race) async {
        do {
            var array = races.value
            guard let index = array.firstIndex(of: race) else { return }
            array[index] = newRace

            _ = try await Amplify.API.mutate(request: .update(array[index]))
            await queryRaces()
        } catch let error as APIError {
            print("Failed to updateRace: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func sendRaceRun(_ run: TrackedPath, _ raceId: String) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            var currentRun = run
            currentRun.notes?.append(user.userId)

            var race = races.value.first { $0.id == raceId }

            race?.tracks?.append(currentRun)
            guard let race else { return }
            _ = try await Amplify.API.mutate(request: .update(race))

            await queryRaces()
        } catch let error as APIError {
            print("Failed to sendRaceRun: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }
    
    func shareRace(_ friend: String, _ race: Race) async {
        do {
            var array = races.value
            guard let index = array.firstIndex(of: race) else { return }
            if let contains = array[index].participants?.contains(friend) {
                if contains {
                    return
                }
            }
            array[index].participants?.append(friend)
            print(array)
            _ = try await Amplify.API.mutate(request: .update(array[index]))
            await queryRaces()
        } catch let error as APIError {
            print("Failed to shareTrack: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }
}
