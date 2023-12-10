import Combine
import CoreLocation
import GoogleMaps
import SwiftUI

extension MapView {
    enum MapMenuState {
        case paused
        case on
        case off
        case raceCreation
        case markersPlaced
        case raceMarkerOpened
    }
    final class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let newLocation = locations.last {
                withAnimation {
                    self.cameraPos = GMSCameraPosition(
                        latitude: newLocation.coordinate.latitude,
                        longitude: newLocation.coordinate.longitude,
                        zoom: 17
                    )
                }
            }
        }
        
        private var cancellables: Set<AnyCancellable> = []
        
        let dateFormatter = DateFormatter()
        var accountService: AccountServiceProtocol
        var friendService: FriendServiceProtocol
        var mapService: MapServiceProtocol
        var locationManager = CLLocationManager()
        var locationTimer: Timer?
        var trackTimer: Timer?
        var raceTracking = false
        
        @Published var isMenuOpen = false
        @Published var mapMenuState = MapMenuState.off
        @Published var track: [TrackedPath] = []
        @Published var cameraPos: GMSCameraPosition
        @Published var trackedPath: TrackedPathModel?
        @Published var selectedRace: Race?
        
        @Published var friendLocations: [Location] = []
        @Published var friendLocation: Location?
        
        @Published var signedIn = false
        @Published var startTime: Date? = nil
        @Published var currentDistance: Double? = nil
        
        @Published var raceName: String = ""
        @Published var showingRaceNameAlert = false
        @Published var raceMarkers: [GMSMarker] = []
        @Published var raceCreationState: RaceCreationState = .not
        
        @Published var selectedPath: TrackedPath?
        @Published var shared: Bool = false
        @Published var cameraPosChanged: Bool = true
        
        var elapsedTime: Double { startTime?.distance(to: Date()) ?? 0 }
        var avgSpeed: Double {
            ((currentDistance ?? 0) / elapsedTime) * 3.6
        }
        init(
            accountService: AccountServiceProtocol,
            mapService: MapServiceProtocol,
            friendService: FriendServiceProtocol
        ) {
            self.accountService = accountService
            self.mapService = mapService
            self.friendService = friendService
            self.cameraPos = .init(
                latitude: self.locationManager.location?.coordinate.latitude ?? 1,
                longitude: self.locationManager.location?.coordinate.longitude ?? 1,
                zoom: 17
            )
            super.init()
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
            
            self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            self.initBindings()
            
            mapService.queryTrackedPaths()
            mapService.querySharedPaths()
            mapService.queryRaces()
        }
        
        func initUser() {
            accountService.initUser()
        }
        
        func confirm() {
            accountService.createUserTrackedPaths()
        }
        
        func raceTrackAction() {
            raceTracking = true
            startTracking()
        }
        
        func initBindings() {
            mapService.trackedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    self?.track = track?.tracks ?? []
                    self?.trackedPath = track
                    self?.refreshSelectedPath()
                }
                .store(in: &cancellables)
            
            accountService.isSignedInPublisher
                .sink(receiveValue: { [weak self] value in
                    self?.signedIn = value
                })
                .store(in: &cancellables)
            
            mapService.raceCreationStatePublisher
                .sink(receiveValue: { [weak self] value in
                    if value == .finished {
                        self?.mapMenuState = .markersPlaced
                    }
                    self?.raceCreationState = value
                })
                .store(in: &cancellables)
        }
        
        @objc
        func updateLocation() {
            Task {
                self.accountService.updateLocation(
                    xCoord: String(locationManager.location?.coordinate.latitude ?? 0),
                    yCoord: String(locationManager.location?.coordinate.longitude ?? 0)
                )
                self.friendService.queryFriendLocations()
            }
        }
        
        func startTracking() {
            self.trackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackRoute), userInfo: nil, repeats: true)
            startTime = Date()
            //            self.trackedPath.append(TrackedPathModel(id: UUID().uuidString, name: "Path \(self.trackedPath.count)"))
            let id = UUID().uuidString
            self.trackedPath?.tracks?.append(
                .init(
                    id: id,
                    name: "Run \(id.prefix(4))",
                    startDate: "\(dateFormatter.string(from: Date()))",
                    endDate: "",
                    notes: [],
                    tracking: true
                )
            )
            self.mapMenuState = .on
        }
        
        func calculateDistance() -> Double {
            guard let track = selectedPath else { return 0.0 }
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
        
        func resumeTracking() {
            self.trackTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackRoute), userInfo: nil, repeats: true)
            self.mapMenuState = .on
        }
        
        func pauseTracking() {
            self.trackTimer?.invalidate()
            self.trackTimer = nil
            self.mapMenuState = .paused
        }
        
        func stopTracking() {
            self.trackTimer?.invalidate()
            self.trackTimer = nil
            self.mapMenuState = .off
            self.startTime = nil
            self.currentDistance = nil
            var current = trackedPath?.tracks?.last
            current?.endDate = "\(dateFormatter.string(from: Date()))"
            guard let path = current else { return }
            if raceTracking {
                mapService.sendRaceRun(path, selectedRace?.id ?? "")
                raceTracking = false
            }
            mapService.updateTrackedPath(path)
        }
        
        @objc
        func trackRoute() {
            guard var modified = self.trackedPath?.tracks else { return }
            var xCoords = modified.last?.xCoords
            var yCoords = modified.last?.yCoords
            
            xCoords?.append(locationManager.location?.coordinate.latitude ?? 0)
            yCoords?.append(locationManager.location?.coordinate.longitude ?? 0)
            
            modified[modified.count - 1].xCoords = xCoords ?? []
            modified[modified.count - 1].yCoords = yCoords ?? []
            modified[modified.count - 1].endDate = "\(dateFormatter.string(from: Date()))"
            self.trackedPath?.tracks = modified
            self.track = modified
            
            
            let track = modified[modified.count - 1]
            var list: [CLLocation] = []
            var distance = 0.0
            for index in 0..<(track.xCoords?.count ?? 0) {
                list.append(CLLocation(latitude: track.xCoords?[index] ?? 0, longitude: track.yCoords?[index] ?? 0))
            }
            if list.count > 1 {
                for itemDx in 1..<list.count {
                    distance += list[itemDx].distance(from: list[itemDx - 1])
                }
            }
            self.currentDistance = distance
            
            guard let modifiedLast = modified.last else { return }
            mapService.sendCurrentlyTracked(modifiedLast)
        }
        
        func stopTimer() {
            self.locationTimer?.invalidate()
        }
        
        func startTimer() {
            self.locationTimer = Timer.scheduledTimer(
                timeInterval: 5,
                target: self,
                selector: #selector(updateLocation),
                userInfo: nil,
                repeats: true
            )
        }
        
        func refreshSelectedPath() {
            guard let selected = selectedPath else { return }
            selectedPath = self.track.first { $0.id == selected.id }
        }
        
        func closeAction() {
            withAnimation {
                selectedPath = nil
            }
            friendService.queryFriendLocations()
        }
        
        func removeTrack(_ trackedPath: TrackedPath) {
            mapService.removeTrackedPath(trackedPath)
        }
        
        func updateTrack(_ trackedPath: TrackedPath, shared: Bool) {
            mapService.updateTrack(trackedPath, shared)
        }
        
        func addNote(_ note: String, _ trackedPath: TrackedPath) {
            var newTrack = trackedPath
            newTrack.notes?.append(note)
            mapService.updateTrack(newTrack, false)
        }
        
        func raceAction(cancel: Bool) {
            if cancel {
                mapMenuState = .off
                mapService.changeRaceCreationState(.not)
                return
            }
            switch raceCreationState {
            case .firstMarker, .secondMarker:
                print("first or second marker")
            case .finished:
                showingRaceNameAlert.toggle()
            case .not:
                startRaceCreation()
                mapMenuState = .raceCreation
            }
            startRaceCreation()
        }
        
        func addRace(_ name: String) {
            mapService.createRace(raceMarkers, name)
            mapMenuState = .off
            raceName = ""
        }
        
        func startRaceCreation() {
            mapService.changeRaceCreationState(.firstMarker)
        }
        
        func checkForRaceFinish() {
            if raceTracking {
                var distanceToFinish = 100.0
                let finishCoord = CLLocation(latitude: selectedRace?.xCoords?[1] ?? 0, longitude: selectedRace?.yCoords?[1] ?? 0)
                distanceToFinish = finishCoord.distance(from: CLLocation(latitude: cameraPos.target.latitude, longitude: cameraPos.target.longitude))
                if distanceToFinish < 100 {
                    stopTracking()
                }
            }
        }
    }
}
