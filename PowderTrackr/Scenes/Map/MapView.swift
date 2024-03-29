import GoogleMaps
import SwiftUI

struct MapView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ViewFactory.googleMap(
                cameraPos: $viewModel.cameraPos,
                selectedPath: $viewModel.selectedPath,
                selectedRace: $viewModel.selectedRace,
                shared: $viewModel.shared,
                cameraPosChanged: $viewModel.cameraPosChanged,
                raceMarkers: $viewModel.raceMarkers
            )
            .ignoresSafeArea()
            topBar
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
                        isOpen: $viewModel.isMenuOpen,
                        mapMenuState: $viewModel.mapMenuState,
                        selectedRace: $viewModel.selectedRace,
                        startAction: viewModel.startTracking,
                        pauseAction: viewModel.pauseTracking,
                        stopAction: viewModel.stopTracking,
                        resumeAction: viewModel.resumeTracking,
                        raceAction: viewModel.raceAction,
                        raceTrackAction: viewModel.raceTrackAction
                    )
                    .customShadow()
                }
            }
        }
        .alert("Name and create race", isPresented: $viewModel.showingRaceNameAlert) {
            TextField("Enter the name...", text: $viewModel.raceName)
                .autocorrectionDisabled(true)
            Button("Create") {
                viewModel.addRace(viewModel.raceName)
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
        .onChange(of: viewModel.selectedRace) { _, newValue in
            if newValue != nil {
                withAnimation {
                    viewModel.mapMenuState = .raceMarkerOpened
                    viewModel.isMenuOpen = true
                }
            }
        }
        .toastMessage(toastMessage: $viewModel.toast)
        .onChange(of: viewModel.cameraPos) { _, newValue in
            print(newValue)
            viewModel.cameraPosChanged = true
            viewModel.checkForRaceFinish()
        }
        .onChange(of: viewModel.isMenuOpen) { _, newValue in
            if viewModel.mapMenuState == .raceMarkerOpened && !newValue {
                viewModel.selectedRace = nil
                viewModel.mapMenuState = .off
            }
        }
        .onDisappear(perform: viewModel.stopTimer)
        .onAppear(perform: viewModel.startTimer)
        .toolbar(.hidden)
    }
    
    @ViewBuilder var topBar: some View {
        if viewModel.isTracking {
            VStack {
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
                .background(.white)
                Spacer()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.mapView()
    }
}
