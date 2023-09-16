import GoogleMaps
import SwiftUI

struct MapView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            ViewFactory.googleMap(
                cameraPos: $viewModel.cameraPos,
                selectedPath: $viewModel.selectedPath,
                shared: $viewModel.shared
            )
            .ignoresSafeArea()
            VStack {
                topBar
                    .background(.white)
                Spacer()
            }
            VStack(alignment: .trailing) {
                Spacer()
                if viewModel.selectedPath != nil {
                    TrackListItem(
                        track: viewModel.selectedPath!, // swiftlint:disable:this force_unwrapping
                        style: viewModel.shared ? .shared : .normal,
                        closeAction: viewModel.closeAction,
                        updateAction: viewModel.updateTrack,
                        noteAction: viewModel.addNote,
                        deleteAction: viewModel.removeTrack,
                        totalDistance: viewModel.calculateDistance(),
                        isOpened: true
                    )
                    .transition(.push(from: .top))
                } else if viewModel.signedIn {
                    LayerWidget(
                        isTracking: $viewModel.isTracking,
                        startAction: viewModel.startTracking,
                        pauseAction: viewModel.pauseTracking,
                        stopAction: viewModel.stopTracking,
                        resumeAction: viewModel.resumeTracking
                    )
                }
            }
        }
        .onChange(of: viewModel.cameraPos) { newValue in
            print(newValue)
        }
        .onDisappear(perform: viewModel.stopTimer)
        .onAppear(perform: viewModel.startTimer)
}

    @ViewBuilder var menu: some View {
        VStack {
            Spacer()
            switch viewModel.menuState {
            case .opened:
                GeometryReader { proxy in
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                viewModel.menuState = .closed
                            }
                        } label: {
                            Text("Close")
                        }
                        Spacer()
                    }
                    .frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.4)
                    .background(Color.white)
                    .cornerRadius(16)
                }

            case .closed:
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
        .padding(16)
    }

    var topBar: some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                Text("\(String(format: "%.f", viewModel.currentDistance ?? 0.0)) m")
                    .bold()
                HStack {
                    Image(systemName: "arrow.forward")
                        .frame(minHeight: 20)
                    Text("distance")
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }
            Divider()
                .padding(.horizontal, 12)
            VStack(spacing: 4) {
                Text("\(String(format: "%.2f", viewModel.elapsedTime)) s")
                    .bold()
                HStack {
                    Image(systemName: "timer")
                    Text("total time")
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }
            Divider()
                .padding(.horizontal, 12)
            VStack(spacing: 4) {
                Text("\(String(format: "%.2f", viewModel.avgSpeed)) km/h")
                    .bold()
                HStack {
                    Image(systemName: "speedometer")
                    Text("avg speed")
                        .font(.caption)
                }
                .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.bottom, 8)
        .frame(maxHeight: 48)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.mapView()
    }
}
