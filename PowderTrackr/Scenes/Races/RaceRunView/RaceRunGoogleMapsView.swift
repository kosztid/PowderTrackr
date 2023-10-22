import Combine
import Factory
import GoogleMaps
import SwiftUI

struct RaceRunGoogleMapsView: UIViewRepresentable {
    class Coordinator: NSObject, GMSMapViewDelegate {
        private var cancellables: Set<AnyCancellable> = []

        var innerMapView: GMSMapView?
        var raceMarkers: [GMSMarker]

        init(
            innerMapView: GMSMapView? = nil,
            raceMarkers: [GMSMarker]
        ) {
            self.innerMapView = innerMapView
            self.raceMarkers = raceMarkers
            super.init()
        }


        func drawMapItems() {
            innerMapView?.clear()

            for marker in raceMarkers {
                marker.map = innerMapView
            }
        }
    }

    @Binding var cameraPos: GMSCameraPosition
    @Binding var raceMarkers: [GMSMarker]

    init(
        cameraPos: Binding<GMSCameraPosition>,
        raceMarkers: Binding<[GMSMarker]>
    ) {
        self._cameraPos = cameraPos
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

        if raceMarkers != context.coordinator.raceMarkers {
            context.coordinator.raceMarkers = raceMarkers
            context.coordinator.drawMapItems()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            raceMarkers: raceMarkers
        )
    }
}
