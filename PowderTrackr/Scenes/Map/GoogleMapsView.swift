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

        @Binding var selectedPath: TrackedPath?
        @Binding var shared: Bool

        init(
            innerMapView: GMSMapView? = nil,
            selectedPath: Binding<TrackedPath?>,
            shared: Binding<Bool>
        ) {
            self.innerMapView = innerMapView
            self.friendService = Container.friendService()
            self.mapService = Container.mapService()
            self.accountService = Container.accountService()
            self._selectedPath = selectedPath
            self._shared = shared
            super.init()

            Task {
                await self.friendService.queryFriendLocations()
            }

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
        }

        func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
            guard let model = lines.first(where: { $0 == overlay })?.userData as? TrackedPath else { return }
            if sharedPath.contains(model) {
                shared = true
            } else {
                shared = false
            }
            self.selectedPath = model
            drawMapItems()
        }

//        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//            guard let model = markers.first(where: { $0 == marker })?.userData as? String else { return false }
//            print(model)
//            return true
//        }

        func drawMapItems() {
            innerMapView?.clear()

            for marker in markers {
                marker.map = innerMapView
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
                tempMarkers.append( marker )
            }
            self.markers = tempMarkers
            drawMapItems()
        }
    }

    @Binding var cameraPos: GMSCameraPosition
    @Binding var selectedPath: TrackedPath?
    @Binding var shared: Bool

    init(
        cameraPos: Binding<GMSCameraPosition>,
        selectedPath: Binding<TrackedPath?>,
        shared: Binding<Bool>
    ) {
        self._cameraPos = cameraPos
        self._selectedPath = selectedPath
        self._shared = shared
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
        Coordinator(selectedPath: $selectedPath, shared: $shared)
    }
}
