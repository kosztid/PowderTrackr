import Combine
import Factory
import GoogleMaps
import SwiftUI

struct GoogleMapsView: UIViewRepresentable {
    class Coordinator: NSObject, GMSMapViewDelegate {
        private var cancellables: Set<AnyCancellable> = []

        let friendService: FriendServiceProtocol
        let mapService: MapServiceProtocol
        let accountService: AccountServiceProtocol
        var innerMapView: GMSMapView?
        var trackedPath: [TrackedPath] = []
        var sharedPath: [TrackedPath] = []
        var currentlyTracked: TrackedPath?
        var friendLocations: [Location] = []
        var markers: [GMSMarker] = []
        var lines: [GMSPolyline] = []
        var races: [Race] = []
        @Binding var raceMarkers: [GMSMarker]

        @Binding var selectedPath: TrackedPath?
        @Binding var selectedRace: Race?
        @Binding var shared: Bool
        @Published var raceCreationState: RaceCreationState = .not

        init(
            innerMapView: GMSMapView? = nil,
            selectedPath: Binding<TrackedPath?>,
            selectedRace: Binding<Race?>,
            shared: Binding<Bool>,
            raceMarkers: Binding<[GMSMarker]>
        ) {
            self.innerMapView = innerMapView
            self.friendService = Container.friendService()
            self.mapService = Container.mapService()
            self.accountService = Container.accountService()
            self._selectedPath = selectedPath
            self._selectedRace = selectedRace
            self._shared = shared
            self._raceMarkers = raceMarkers
            super.init()

            Task {
                await self.friendService.queryFriendLocations()
            }

            mapService.raceCreationStatePublisher
                .sink { [weak self] state in
                    self?.raceCreationState = state
                    if state == .not {
                        self?.raceMarkers = []
                        self?.drawMapItems()
                    }
                }
                .store(in: &cancellables)

            friendService.friendPositionsPublisher
                .sink { _ in
                } receiveValue: { [weak self] loc in
                    self?.friendLocations = loc
                    self?.makeMarkers()
                }
                .store(in: &cancellables)

            mapService.trackedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    self?.trackedPath = track?.tracks ?? []
                    self?.drawMapItems()
                }
                .store(in: &cancellables)

            mapService.sharedPathPublisher
                .sink { _ in
                } receiveValue: { [weak self] track in
                    self?.sharedPath = track?.tracks ?? []
                    self?.drawMapItems()
                }
                .store(in: &cancellables)

            mapService.trackingPublisher
                .sink { _ in
                } receiveValue: { [weak self] currentTrack in
                    self?.currentlyTracked = currentTrack
                    self?.drawMapItems()
                }
                .store(in: &cancellables)

            accountService.isSignedInPublisher
                .sink(receiveValue: { [weak self] value in
                    if value == false {
                        self?.trackedPath = []
                        self?.friendLocations = []
                        self?.markers = []
                        self?.drawMapItems()
                    }
                })
                .store(in: &cancellables)

            mapService.racesPublisher
                .sink(receiveValue: { [weak self] value in
                    self?.races = value
                    self?.makeMarkers()
                })
                .store(in: &cancellables)
        }

        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            guard let race = marker.userData as? Race else { return false }
            selectedRace = race
            return true
        }
        func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
            guard let model = lines.first(where: { $0 == overlay })?.userData as? TrackedPath else { return }
            if sharedPath.contains(model) {
                shared = true
            } else {
                shared = false
            }
            withAnimation {
                self.selectedPath = model
            }

            drawMapItems()
        }

        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            switch raceCreationState {
            case .firstMarker:
                if raceMarkers.count == 0 {
                    raceMarkers.append(GMSMarker(position: coordinate))
                    mapService.changeRaceCreationState(.secondMarker)
                } else {
                    raceMarkers[0] = GMSMarker(position: coordinate)
                }
            case .secondMarker:
                if raceMarkers.count == 1 {
                    raceMarkers.append(GMSMarker(position: coordinate))
                    mapService.changeRaceCreationState(.finished)
                } else {
                    raceMarkers[1] = GMSMarker(position: coordinate)
                }
            case .not, .finished:
                return
            }
            drawMapItems()
        }

        func drawMapItems() {
            innerMapView?.clear()

            for marker in markers {
                marker.map = innerMapView
            }

            for raceMarker in raceMarkers {
                raceMarker.map = innerMapView
            }

            makePolylines()
        }

        func makePolylines() {
            lines.removeAll()
            var list = trackedPath
            if let current = currentlyTracked {
                list.append(current)
            }

            list.append(contentsOf: sharedPath)
            
            for track in list where track.tracking {
                let path = GMSMutablePath()
                for index in 0..<(track.xCoords?.count ?? 0) {
                    path.add(CLLocationCoordinate2D(latitude: track.xCoords?[index] ?? 0, longitude: track.yCoords?[index] ?? 0))
                }
                let line = GMSPolyline(path: path)
                line.strokeColor = selectedPath == track ? UIColor.red : UIColor.blue
                line.strokeWidth = 3.0
                line.map = innerMapView
                line.isTappable = true
                line.userData = track
                lines.append(line)
            }
        }

        func makeMarkers() {
            var tempMarkers: [GMSMarker] = []
            friendLocations.forEach { loc in
                let marker = GMSMarker(
                    position: CLLocationCoordinate2D(
                        latitude: Double(loc.xCoord ?? "") ?? 0,
                        longitude: Double(loc.yCoord ?? "") ?? 0
                    )
                )
                marker.title = loc.name
                let icon = UIImage(systemName: "person.fill")
                marker.icon = icon

                marker.userData = loc.id
                tempMarkers.append(marker)
            }

            races.forEach { race in
                let marker = GMSMarker(
                    position: CLLocationCoordinate2D(
                        latitude: race.xCoords?[0] ?? 0,
                        longitude: race.yCoords?[0] ?? 0
                    )
                )
                marker.title = race.name
                let icon = UIImage(systemName: "flag")
                marker.icon = icon

                marker.userData = race
                tempMarkers.append(marker)
            }

            self.markers = tempMarkers
            drawMapItems()
        }
    }

    @Binding var cameraPos: GMSCameraPosition
    @Binding var selectedPath: TrackedPath?
    @Binding var selectedRace: Race?
    @Binding var shared: Bool
    @Binding var raceMarkers: [GMSMarker]

    init(
        cameraPos: Binding<GMSCameraPosition>,
        selectedPath: Binding<TrackedPath?>,
        selectedRace: Binding<Race?>,
        shared: Binding<Bool>,
        raceMarkers: Binding<[GMSMarker]>
    ) {
        self._cameraPos = cameraPos
        self._selectedPath = selectedPath
        self._selectedRace = selectedRace
        self._shared = shared
        self._raceMarkers = raceMarkers
    }

    func makeUIView(context: Context) -> GMSMapView {
        GMSServices.setMetalRendererEnabled(true)
        let view = GMSMapView.map(
            withFrame: .zero,
            camera: cameraPos
        )
        view.isMyLocationEnabled = true
        view.delegate = context.coordinator
        view.mapType = .terrain
        context.coordinator.innerMapView = view

        return view
    }

    func updateUIView(_ view: GMSMapView, context: Context) {
        if cameraPos != view.camera {
            if context.transaction.animation != nil {
                view.animate(with: GMSCameraUpdate.setCamera(cameraPos))
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            selectedPath: $selectedPath,
            selectedRace: $selectedRace,
            shared: $shared,
            raceMarkers: $raceMarkers
        )
    }
}
