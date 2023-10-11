import GoogleMaps
import SwiftUI

struct MapView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            ViewFactory.googleMap(
                cameraPos: $viewModel.cameraPos,
                selectedPath: $viewModel.selectedPath,
                shared: $viewModel.shared,
                raceMarkers: $viewModel.raceMarkers
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
                        mapMenuState: $viewModel.mapMenuState,
                        startAction: viewModel.startTracking,
                        pauseAction: viewModel.pauseTracking,
                        stopAction: viewModel.stopTracking,
                        resumeAction: viewModel.resumeTracking,
                        raceAction: viewModel.raceAction
                    )
                }
            }
            Button("Init race") {
                viewModel.initRace()
            }
        }
        .alert("Name and create race", isPresented: $viewModel.showingRaceNameAlert) {
            TextField("Enter the name...", text: $viewModel.raceName)
                .autocorrectionDisabled(true)
            Button("Create") {
                viewModel.addRace()
                viewModel.showingRaceNameAlert.toggle()
            }
            Button(
                "Cancel",
                role: .cancel
            ) {
                viewModel.raceName = ""
                viewModel.showingRaceNameAlert.toggle()
            }
        }
        .onChange(of: viewModel.cameraPos) { newValue in
            print(newValue)
        }
        .onDisappear(perform: viewModel.stopTimer)
        .onAppear(perform: viewModel.startTimer)
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
