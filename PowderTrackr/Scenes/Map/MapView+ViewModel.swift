import Combine
import WatchConnectivity
import WidgetKit
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
        var watchConnectivityProvider: WatchConnectivityProvider
        var locationManager = CLLocationManager()
        var locationTimer: Timer?
        var trackTimer: Timer?
        var widgetTimer: Timer?
        
        @Published var isTracking = false
        @Published var raceTracking = false
        @Published var isMenuOpen = false
        @Published var mapMenuState = MapMenuState.off
        @Published var track: [TrackedPath] = []
        @Published var cameraPos: GMSCameraPosition
        @Published var trackedPath: TrackedPathModel?
        @Published var selectedRace: Race?
        @Published var toast: ToastModel?
        
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
        
        @AppStorage("elapsedTime", store: UserDefaults(suiteName: "group.koszti.PowderTrackr")) var elapsedTimeStorage: Double = 0.0
        @AppStorage("avgSpeed", store: UserDefaults(suiteName: "group.koszti.PowderTrackr")) var avgSpeedStorage: Double = 0.0
        @AppStorage("distance", store: UserDefaults(suiteName: "group.koszti.PowderTrackr")) var distanceStorage: Double = 0.0
        @AppStorage("isTracking", store: UserDefaults(suiteName: "group.koszti.PowderTrackr")) var isTrackingStorage: Bool = false
        
        var elapsedTime: Double { 
            startTime?.distance(to: Date()) ?? 0
        }
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
            self.watchConnectivityProvider = WatchConnectivityProvider()
            self.cameraPos = .init(
                latitude: self.locationManager.location?.coordinate.latitude ?? 1,
                longitude: self.locationManager.location?.coordinate.longitude ?? 1,
                zoom: 17
            )
            super.init()
            self.locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
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
                    guard let self else { return }
                    if self.signedIn {
                        self.track = track?.tracks ?? []
                        self.trackedPath = track
                        self.refreshSelectedPath()
                    } else {
                        self.trackedPath = nil
                        self.track = []
                    }
                    
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
            
            mapService.networkErrorPublisher
                .sink { [weak self] model in
                    self?.toast = model
                }
                .store(in: &cancellables)
        }
        
        @objc
        func updateLocation() {
            self.accountService.updateLocation(
                xCoord: String(locationManager.location?.coordinate.latitude ?? .zero),
                yCoord: String(locationManager.location?.coordinate.longitude ?? .zero)
            )
            self.friendService.queryFriendLocations()
        }
        
        func startTracking() {
            isTrackingStorage = true
            WidgetCenter.shared.reloadTimelines(ofKind: "PowderTrackrWidget")
            watchConnectivityProvider.sendIsTracking(isTracking: true)
            withAnimation {
                isTracking = true
            }
            self.trackTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(trackRoute), userInfo: nil, repeats: true)
            self.widgetTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateWidget), userInfo: nil, repeats: true)
            startTime = Date()
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
            for index in .zero..<(track.xCoords?.count ?? .zero) {
                list.append(CLLocation(latitude: track.xCoords?[index] ?? .zero, longitude: track.yCoords?[index] ?? .zero))
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
            isTrackingStorage = false
            watchConnectivityProvider.sendIsTracking(isTracking: false)
            WidgetCenter.shared.reloadTimelines(ofKind: "PowderTrackrWidget")
            withAnimation {
                isTracking = false
            }
            self.trackTimer?.invalidate()
            self.trackTimer = nil
            self.widgetTimer = nil
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
        func updateWidget() {
            let time = startTime?.distance(to: Date()) ?? 0
            elapsedTimeStorage = time
            avgSpeedStorage = ((currentDistance ?? 0) / time) * 3.6
            distanceStorage = currentDistance ?? 0
            WidgetCenter.shared.reloadTimelines(ofKind: "PowderTrackrWidget")
        }
        
        func updateWatchData() {
            guard let currentDistance else { return }
            watchConnectivityProvider.sendMetrics(elapsedTime: elapsedTime, avgSpeed: avgSpeed, distance: currentDistance)
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
            currentDistance = distance
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
        }
        
        func addRace(_ name: String) {
            mapService.createRace(raceMarkers, name)
            mapMenuState = .off
            raceName = ""
        }
        
        func startRaceCreation() {
            print("called")
            mapService.changeRaceCreationState(.firstMarker)
        }
        
        func checkForRaceFinish() {
            if raceTracking {
                var distanceToFinish = 100.0
                let finishCoord = CLLocation(latitude: selectedRace?.xCoords?[1] ?? 0, longitude: selectedRace?.yCoords?[1] ?? 0)
                distanceToFinish = finishCoord.distance(from: CLLocation(latitude: cameraPos.target.latitude, longitude: cameraPos.target.longitude))
                if distanceToFinish < 30 {
                    stopTracking()
                }
            }
        }
    }
}
