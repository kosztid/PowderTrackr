import GoogleMaps
import SwiftUI

struct MapView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            ViewFactory.googleMap(
                cameraPos: $viewModel.cameraPos,
                selectedPath: $viewModel.selectedPath
            )
            .ignoresSafeArea()
            VStack(spacing: .zero) {
                Spacer()
                if viewModel.selectedPath != nil {
                    TrackListItem(
                        track: viewModel.selectedPath!, // swiftlint:disable:this force_unwrapping
                        closeAction: viewModel.closeAction,
                        updateAction: viewModel.updateTrack,
                        noteAction: viewModel.addNote,
                        deleteAction: viewModel.removeTrack,
                        totalDistance: viewModel.calculateDistance(),
                        isOpened: true
                    )
                    .transition(.push(from: .top))
                } else if viewModel.signedIn {
                    HStack {
                        if viewModel.isTracking == .off {
                            Spacer()
                            Button {
                                viewModel.startTracking()
                            } label: {
                                Text("Start Tracking")
                            }
                            .buttonStyle(SkiingButtonStyle())
                        } else {
                            if viewModel.isTracking == .on {
                                Button {
                                    viewModel.pauseTracking()
                                } label: {
                                    Text("Pause")
                                }
                                .buttonStyle(SkiingButtonStyle())

                                Button {
                                    viewModel.stopTracking()
                                } label: {
                                    Text("Stop")
                                }
                                .buttonStyle(SkiingButtonStyle())
                            } else {
                                Button {
                                    viewModel.resumeTracking()
                                } label: {
                                    Text("Resume")
                                }
                                .buttonStyle(SkiingButtonStyle())

                                Button {
                                    viewModel.stopTracking()
                                } label: {
                                    Text("Stop")
                                }
                                .buttonStyle(SkiingButtonStyle())
                            }
                        }
                    }
                    .transition(.push(from: .top))
                    .padding()
                }
            }
        }
        .onChange(of: viewModel.cameraPos) { newValue in
            print(newValue)
        }
    }
}
