import SwiftUI

struct RaceRunView: View {
    private typealias Str = Rsc.RaceRunView
    private enum Layout {
        static let playerHeight: CGFloat = 200
        static let positionTickWidth: CGFloat = 200
    }

    @StateObject var viewModel: ViewModel
    @State var playerOpened = false

    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text(Str.Race.label)
                    .textStyle(.body)
                Spacer()
            }
            HStack {
                Text(viewModel.race.name)
                    .textStyle(.h4)
                Spacer()
                Text(viewModel.race.endDate)
                    .textStyle(.bodyLarge)
            }
            Divider()
                .padding(.vertical, .su4)
            dataSection
            playerSection
        }
        .padding(.vertical, .su16)
        .padding(.horizontal, .su8)
        .background(Color.softWhite)
        .cornerRadius(.su16)
        .padding(.su8)
        .customShadow()
        .onChange(of: viewModel.currentArrayIndex) { _, index in
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
                        Text(Str.Player.label)
                            .textStyle(.bodyLarge)
                        Spacer()
                        Image(systemName: playerOpened ? "arrowtriangle.up" : "arrowtriangle.down")
                            .resizable()
                            .frame(width: .su24, height: .su24)
                    }
                    .frame(height: .su20)
                }
            }
            if playerOpened {
                ViewFactory.raceRunGoogleMap(cameraPos: $viewModel.cameraPos, raceMarkers: $viewModel.raceMarkers)
                    .frame(height: Layout.playerHeight)
                    .cornerRadius(.su16)
                Grid(horizontalSpacing: .zero) {
                    GridRow {
                        ForEach(0..<100) { index in
                            ZStack {
                                // player
                                if index == Int(viewModel.playerPosition) {
                                    Rectangle().fill().frame(width: .su2, height: .su32)
                                        .foregroundColor(.blue)
                                }
                                if index == Int(viewModel.opponentPosition) && viewModel.closestRun != nil {
                                    Rectangle().fill().frame(width: Layout.positionTickWidth, height: .su32).foregroundColor(.red)
                                }
                                Rectangle().fill().frame(height: .su2).foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding(.vertical, .su16)
                HStack {
                    Spacer()
                    Button(Str.Player.speed(viewModel.playSpeed)) {
                        viewModel.setSpeed()
                    }
                    .padding(.horizontal, .su8)
                    .buttonStyle(SkiingButtonStyle(style: .bordered))
                    Button {
                        viewModel.playButtonTap()
                    } label: {
                        Image(systemName: viewModel.playerState == .playing ? "pause" : "play")
                            .resizable()
                            .frame(width: .su24, height: .su24)
                            .foregroundColor(.bluePrimary)
                    }
                }
            }
        }
    }
    var dataSection: some View {
        Group {
            HStack {
                Text(Str.Data.Distance.label)
                    .textStyle(.body)
                Text(Str.Data.Distance.description(String(format: "%.f", viewModel.totalDistance)))
                    .textStyle(.bodyBold)
                Spacer()
            }
            HStack {
                Text(Str.Data.Time.label)
                    .textStyle(.body)
                Text("\(viewModel.elapsedTimeInString)")
                    .textStyle(.bodyBold)
                Spacer()
                if viewModel.player >= .zero {
                    Text(Str.Player.percentage((viewModel.player)))
                        .textStyle(.bodyBold)
                }
            }
        }
        .padding(.bottom, .su8)
    }
}

struct RaceRunView_Previews: PreviewProvider {
    static var previews: some View {
        ViewFactory.raceRunView(closestRun: .init(id: "Race123", name: "Race123", startDate: "2024-02-18 15:04:01", endDate: "2024-02-18 15:08:01", xCoords: [47.26341597142122, 47.26338860528187, 47.263212975589646], yCoords: [14.354847300931688, 14.35446718299464, 14.354439605161424], tracking: false), race: .init(id: "Race124", name: "Race124", startDate: "2024-02-18 15:04:01", endDate: "2024-02-18 15:08:01", xCoords: [47.26341597142122, 47.26338860528187, 47.263212975589646], yCoords: [14.354847300931688, 14.35446718299464, 14.354439605161424], tracking: false))
    }
}

func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int) {
    ((seconds % 3_600) / 60, (seconds % 3_600) % 60)
}

func printSecondsToHoursMinutesSeconds(_ seconds: Int) -> String {
  let (m, s) = secondsToHoursMinutesSeconds(seconds)
    return String("\(String(format: "%02d", m)):\(String(format: "%02d", s))")
}
