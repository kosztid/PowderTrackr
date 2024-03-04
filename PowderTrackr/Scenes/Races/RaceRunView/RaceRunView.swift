import SwiftUI

struct RaceRunView: View {
    @StateObject var viewModel: ViewModel
    @State var playerOpened = false

    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("Race name")
                    .font(.callout)
                    .bold()
                Spacer()
            }
            HStack {
                Text(viewModel.race.name)
                    .font(.title)
                Spacer()
                Text(viewModel.race.endDate)
            }
            Divider()
                .padding(.vertical, 4)

            dataSection
            playerSection
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(.white)
        .cornerRadius(16)
        .padding(8)
        .shadow(
            color: .gray.opacity(0.6),
            radius: 4,
            x: .zero,
            y: 4
        )
        .onChange(of: viewModel.currentArrayIndex) { index in
            viewModel.calculateDistanceFromStartingPoint(index: index)
        }
    }

    var playerSection: some View {
        VStack {
            HStack {
                Button {
                    playerOpened.toggle()
                } label: {
                    HStack {
                        Text("Player")
                            .font(.system(size: 18))
                        Spacer()
                        Image(systemName: playerOpened ? "arrowtriangle.up" : "arrowtriangle.down")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .frame(height: 20)
                }
            }
            if playerOpened {
                ViewFactory.raceRunGoogleMap(cameraPos: $viewModel.cameraPos, raceMarkers: $viewModel.raceMarkers)
                    .frame(height: 200)
                    .cornerRadius(16)
                Grid(horizontalSpacing: .zero) {
                    GridRow {
                        ForEach(0..<100) { index in
                            ZStack {
                                // player
                                if index == Int(viewModel.playerPosition) {
                                    Rectangle().fill().frame(width: 2, height: 32)
                                        .foregroundColor(.blue)
                                }
                                if index == Int(viewModel.opponentPosition) && viewModel.closestRun != nil {
                                    Rectangle().fill().frame(width: 1, height: 32).foregroundColor(.red)
                                }
                                Rectangle().fill().frame(height: 2).foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding(.vertical, 16)
                HStack {
                    Spacer()
                    Button {
                        viewModel.setSpeed()
                    } label: {
                        Text("\(Int(viewModel.playSpeed))x")
                    }
                    .padding(.horizontal, 8)
                    Button {
                        viewModel.playButtonTap()
                    } label: {
                        Image(systemName: viewModel.playerState == .playing ? "pause" : "play")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    var dataSection: some View {
        Group {
            HStack {
                Text("Distance:")
                Text("\(viewModel.totalDistance, specifier: "%.f") meters")
                    .italic()
                Spacer()
            }
            HStack {
                Text("Time:")
                Text("\(viewModel.elapsedTimeInString)")
                    .italic()
                Spacer()
                if viewModel.player >= .zero {
                    Text("\(viewModel.player) %")
                }
            }
        }
        .padding(.bottom, 8)
    }
}

struct RaceRunView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.raceRunView(closestRun: .init(id: "Race123", name: "Race123", startDate: "2024-02-18 15:04:01", endDate: "2024-02-18 15:08:01", xCoords: [47.26341597142122, 47.26338860528187, 47.263212975589646], yCoords: [14.354847300931688, 14.35446718299464, 14.354439605161424], tracking: false), race: .init(id: "Race124", name: "Race124", startDate: "2024-02-18 15:04:01", endDate: "2024-02-18 15:08:01", xCoords: [47.26341597142122, 47.26338860528187, 47.263212975589646], yCoords: [14.354847300931688, 14.35446718299464, 14.354439605161424], tracking: false))
    }
}

func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int) {
    return ((seconds % 3600) / 60, (seconds % 3600) % 60)
}

func printSecondsToHoursMinutesSeconds(_ seconds: Int) -> String {
  let (m, s) = secondsToHoursMinutesSeconds(seconds)
    return String("\(String(format: "%02d",m)):\(String(format: "%02d",s))")
}
