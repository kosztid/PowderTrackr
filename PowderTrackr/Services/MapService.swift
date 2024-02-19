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
    
    func updateTrackedPath(_ trackedPath: TrackedPath)
    func updateTrack(_ trackedPath: TrackedPath, _ shared: Bool)
    func shareTrack(_ trackedPath: TrackedPath, _ friend: String)
    func removeTrackedPath(_ trackedPath: TrackedPath)
    func removeSharedTrackedPath(_ trackedPath: TrackedPath)
    func queryTrackedPaths()
    func querySharedPaths()
    func sendCurrentlyTracked(_ trackedPath: TrackedPath)
    func changeRaceCreationState(_ raceCreationState: RaceCreationState)
    func createRace(_ markers: [GMSMarker], _ name: String)
    func queryRaces()
    func sendRaceRun(_ run: TrackedPath, _ raceId: String)
    func updateRace(_ race: Race, _ newRace: Race)
    func shareRace(_ friend: String, _ race: Race)
    func deleteRace(_ race: Race)
}

final class MapService {
    private let userID: String = UserDefaults.standard.string(forKey: "id") ?? ""
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
    
    func sendCurrentlyTracked(_ trackedPath: TrackedPath) {
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
    
    
    // TODO: bugs sometimes
    func shareTrack(_ trackedPath: TrackedPath, _ friend: String) {
        var trackedPathModel: TrackedPathModel?
        var sharedTrackedPathModel: TrackedPathModel?
        
        DefaultAPI.userTrackedPathsGet { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                trackedPathModel = data?.map { path in
                    TrackedPathModel(id: path.id, tracks: path.tracks)
                }
                .first { item in
                    item.id == friend
                }
                
                sharedTrackedPathModel = data?.map { path in
                    TrackedPathModel(id: path.id, tracks: path.sharedTracks)
                }
                .first { item in
                    item.id == friend
                }
                
                sharedTrackedPathModel?.tracks?.append(trackedPath)
                
                let newData = UserTrackedPaths(id: friend, tracks: trackedPathModel?.tracks, sharedTracks: sharedTrackedPathModel?.tracks)
                DefaultAPI.userTrackedPathsPut(userTrackedPaths: newData) { data, error in
                    if let error = error {
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
    
    func queryTrackedPaths() {
        var currentPaths: TrackedPathModel?
        
        DefaultAPI.userTrackedPathsGet { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                currentPaths = data?.map { path in
                    let model = TrackedPathModel(id: path.id, tracks: path.tracks)
                    return model
                }.first { item in
                    item.id == self.userID
                }
                self.trackedPathModel.send(currentPaths)
            }
        }
    }
    
    func querySharedPaths() {
        var sharedTracks: TrackedPathModel?
        
        DefaultAPI.userTrackedPathsGet { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                sharedTracks = data?.map { path in
                    TrackedPathModel(id: path.id, tracks: path.sharedTracks)
                }
                .first { item in
                    item.id == self.userID
                }
                self.sharedPathModel.send(sharedTracks)
            }
        }
    }
    
    func updateTrackedPath(_ trackedPath: TrackedPath) {
        var tracks: [TrackedPath] = []
        var sharedTracks: [TrackedPath] = []
        
        tracks = self.trackedPathModel.value?.tracks ?? []
        sharedTracks = self.sharedPathModel.value?.tracks ?? []
        
        let data = UserTrackedPaths(id: userID, tracks: tracks, sharedTracks: sharedTracks)
        DefaultAPI.userTrackedPathsPut(userTrackedPaths: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                self.queryTrackedPaths()
            }
        }
    }
    
    func updateTrack(_ trackedPath: TrackedPath, _ shared: Bool) {
        
        var tracks: [TrackedPath] = []
        var sharedTracks: [TrackedPath] = []
        
        tracks = self.trackedPathModel.value?.tracks ?? []
        sharedTracks = self.sharedPathModel.value?.tracks ?? []
        
        if shared {
            let id = sharedTracks.firstIndex { $0.id == trackedPath.id } ?? 0
            sharedTracks[id] = trackedPath
        } else {
            let id = tracks.firstIndex { $0.id == trackedPath.id } ?? 0
            tracks[id] = trackedPath
        }
        
        let data = UserTrackedPaths(id: UserDefaults.standard.string(forKey: "id") ?? "", tracks: tracks, sharedTracks: sharedTracks)
        
        DefaultAPI.userTrackedPathsPut(userTrackedPaths: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                if shared {
                    self.querySharedPaths()
                } else {
                    self.queryTrackedPaths()
                }
            }
        }
    }
    
    func removeTrackedPath(_ trackedPath: TrackedPath) {
        
        var tracks: [TrackedPath] = []
        
        tracks = self.trackedPathModel.value?.tracks ?? []
        
        tracks.removeAll { $0.id == trackedPath.id }
        
        let trackModel = TrackedPathModel(id: userID, tracks: tracks)
        guard let data = trackModel.data else { return }
        
        DefaultAPI.userTrackedPathsPut(userTrackedPaths: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                self.queryTrackedPaths()
            }
        }
    }
    
    func removeSharedTrackedPath(_ trackedPath: TrackedPath) {
        var tracks: [TrackedPath] = []
        var sharedTracks: [TrackedPath] = []
        
        tracks = self.trackedPathModel.value?.tracks ?? []
        sharedTracks = self.sharedPathModel.value?.tracks ?? []
        
        sharedTracks.removeAll { $0.id == trackedPath.id }
        
        let newData = UserTrackedPaths(id: userID, tracks: tracks, sharedTracks: sharedTracks)
        
        DefaultAPI.userTrackedPathsPut(userTrackedPaths: newData) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                self.querySharedPaths()
            }
        }
    }
    
    func changeRaceCreationState(_ raceCreationState: RaceCreationState) {
        self.raceCreationState.send(raceCreationState)
    }
    
    func createRace(_ markers: [GMSMarker], _ name: String) {
        raceCreationState.send(.not)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let xCoords: [Double]? = markers.map { $0.position.latitude }
        let yCoords: [Double]? = markers.map { $0.position.longitude }
        let race = Race(name: name, date: dateFormatter.string(from: Date()), shortestTime: -1, shortestDistance: -1, xCoords: xCoords ?? [], yCoords: yCoords ?? [], tracks: [], participants: [userID])
        
        DefaultAPI.racesPut(race: race) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                self.queryRaces()
            }
        }
    }
    
    func deleteRace(_ race: Race) {
        DefaultAPI.racesIdDelete(id: race.id) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                var currentRaces = self.races.value
                currentRaces.removeAll { $0.id == race.id }
                self.races.send(currentRaces)
            }
        }
    }
    
    func queryRaces() {
        DefaultAPI.racesGet { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                let filteredResult = data?.filter { race in
                    guard let participants = race.participants else { return false }
                    if participants.contains(self.userID) {
                        return true
                    } else {
                        return false
                    }
                }
                self.races.send(filteredResult ?? [])
            }
        }
    }
    
    func updateRace(_ race: Race, _ newRace: Race) {
            var array = races.value
            guard let index = array.firstIndex(of: race) else { return }
            array[index] = newRace
            
            DefaultAPI.racesPut(race: array[index]) { data, error in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    self.queryRaces()
                }
            }
    }
    
    func sendRaceRun(_ run: TrackedPath, _ raceId: String) {
        var currentRun = run
        currentRun.notes?.append(userID)
        
        var race = races.value.first { $0.id == raceId }
        
        race?.tracks?.append(currentRun)
        guard let race else { return }
        
        DefaultAPI.racesPut(race: race) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                self.queryRaces()
            }
        }
    }
    
    func shareRace(_ friend: String, _ race: Race) {
        var array = races.value
        guard let index = array.firstIndex(of: race) else { return }
        if let contains = array[index].participants?.contains(friend) {
            if contains {
                return
            }
        }
        array[index].participants?.append(friend)
        DefaultAPI.racesPut(race: array[index]) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                self.queryRaces()
            }
        }
    }
}
