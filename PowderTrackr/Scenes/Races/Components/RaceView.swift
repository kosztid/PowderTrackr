import SwiftUI

struct RaceView: View {
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("Race")
                    .font(.callout)
                    .bold()
                Spacer()
            }
            HStack {
                Text("Race")
                    .font(.title)
                Spacer()
                Text("2023-09-30")
            }
            Grid(horizontalSpacing: .zero) {
                GridRow {
                    ForEach(0..<7) {_ in
                        Rectangle().fill().frame(height: 2).foregroundColor(.blue)
                    }
                }
                GridRow {
                    ForEach(0..<7) { count in
                        Text(printSecondsToHoursMinutesSeconds(count * 30))
                    }
                }
            }
            .padding(.vertical, 16)
        }
        .padding(16)
        .cornerRadius(16)
    }
}

struct RaceView_Previews: PreviewProvider {
    static var previews: some View {
        RaceView()
    }
}

func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int) {
    return ((seconds % 3600) / 60, (seconds % 3600) % 60)
}

func printSecondsToHoursMinutesSeconds(_ seconds: Int) -> String {
  let (m, s) = secondsToHoursMinutesSeconds(seconds)
    return String("\(String(format: "%02d",m)):\(String(format: "%02d",s))")
}
