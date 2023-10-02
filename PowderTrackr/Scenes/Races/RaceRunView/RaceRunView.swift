import SwiftUI

struct RaceRunView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("Race name")
                    .font(.callout)
                    .bold()
                Spacer()
            }
            HStack {
                Text(viewModel.race)
                    .font(.title)
                Spacer()
                Text("2023-09-30")
            }
            Divider()
                .padding(.vertical, 4)
            dataSection
            Grid(horizontalSpacing: .zero) {
                GridRow {
                    ForEach(0..<7) { index in
                        ZStack {
                            if index == viewModel.player {
                                Rectangle().fill().frame(width: 2, height: 32)
                            }
                            Rectangle().fill().frame(height: 2).foregroundColor(.blue)
                        }
                    }
                }
                GridRow {
                    ForEach(0..<7) { count in
                        Text(printSecondsToHoursMinutesSeconds(count * 30))
                    }
                }
            }
            .padding(.vertical, 16)
            HStack {
                Spacer()
                Button {
                    viewModel.playButtonTap()
                } label : {
                    Image(systemName: viewModel.playerState == .playing ? "pause" : "play")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                }
            }
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
    }

    var dataSection: some View {
        Group {
            HStack {
                Text("Distance:")
                Text("11324 meters")
                    .italic()
                Spacer()
            }
            HStack {
                Text("Time:")
                Text("12:32 min")
                    .italic()
                Spacer()
            }
        }
    }
}

struct RaceRunView_Previews: PreviewProvider {
    static var previews: some View {
        RaceRunView(viewModel: .init(race: "Race"))
    }
}

func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int) {
    return ((seconds % 3600) / 60, (seconds % 3600) % 60)
}

func printSecondsToHoursMinutesSeconds(_ seconds: Int) -> String {
  let (m, s) = secondsToHoursMinutesSeconds(seconds)
    return String("\(String(format: "%02d",m)):\(String(format: "%02d",s))")
}
