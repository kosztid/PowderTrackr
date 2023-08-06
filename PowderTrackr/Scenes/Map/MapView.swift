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
            menu
                .padding(16)
            //            VStack(spacing: .zero) {
            //                Spacer()
            //                if viewModel.selectedPath != nil {
            //                    TrackListItem(
            //                        track: viewModel.selectedPath!, // swiftlint:disable:this force_unwrapping
            //                        closeAction: viewModel.closeAction,
            //                        updateAction: viewModel.updateTrack,
            //                        noteAction: viewModel.addNote,
            //                        deleteAction: viewModel.removeTrack,
            //                        totalDistance: viewModel.calculateDistance(),
            //                        isOpened: true
            //                    )
            //                    .transition(.push(from: .top))
            //                } else if viewModel.signedIn {
            //                    HStack {
            //                        if viewModel.isTracking == .off {
            //                            Spacer()
            //                            Button {
            //                                viewModel.startTracking()
            //                            } label: {
            //                                Text("Start Tracking")
            //                            }
            //                            .buttonStyle(SkiingButtonStyle())
            //                        } else {
            //                            if viewModel.isTracking == .on {
            //                                Button {
            //                                    viewModel.pauseTracking()
            //                                } label: {
            //                                    Text("Pause")
            //                                }
            //                                .buttonStyle(SkiingButtonStyle())
            //
            //                                Button {
            //                                    viewModel.stopTracking()
            //                                } label: {
            //                                    Text("Stop")
            //                                }
            //                                .buttonStyle(SkiingButtonStyle())
            //                            } else {
            //                                Button {
            //                                    viewModel.resumeTracking()
            //                                } label: {
            //                                    Text("Resume")
            //                                }
            //                                .buttonStyle(SkiingButtonStyle())
            //
            //                                Button {
            //                                    viewModel.stopTracking()
            //                                } label: {
            //                                    Text("Stop")
            //                                }
            //                                .buttonStyle(SkiingButtonStyle())
            //                            }
            //                        }
            //                    }
            //                    .transition(.push(from: .top))
            //                    .padding()
            //                }
            //            }
        }
        .onChange(of: viewModel.cameraPos) { newValue in
            print(newValue)
        }
    }

    @ViewBuilder var menu: some View {
        switch viewModel.menuState {
        case .opened:
            VStack {
                Spacer()
                HStack {
                    Button {
                        withAnimation {
                            viewModel.menuState = .closed
                        }
                    } label: {
                        Text("Close")
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal, 16)
            }
        case .closed:
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            viewModel.menuState = .opened
                        }
                    } label: {
                        Image(systemName: "text.justify")
                            .bold()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.teal)
                            .cornerRadius(16)
                    }
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.mapView()
    }
}
