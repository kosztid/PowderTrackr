import CoreLocation
import SwiftUI

struct TrackDetail: View {
    let track: TrackedPath
    @Namespace private var namespace
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            HStack {
                Text(track.name)
                    .bold()
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Date")
                    Text(track.startDate)
                        .bold()
                }
            }
            .tag(0)

            VStack(spacing: .su4) {
                HStack {
                    Text("Total distance moved:")
                    Spacer()
                    Text("\(calculateDistance(), specifier: "%.f") meters")
                }
                .padding(.bottom, .su4)
                HStack {
                    Text("Duration:")
                    Spacer()
                    Text("\(elapsedTime())")
                }
                .padding(.bottom, .su8)
            }
            .tag(1)

            ScrollView {
                if let notes = track.notes, notes.isEmpty {
                    Text("You have no notes for this track")
                } else {
                    VStack {
                        ForEach(track.notes ?? [], id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .tag(2)
        }
#if os(watchOS)
        .tabViewStyle(.verticalPage)
#endif
        .padding(.su4)
    }
}

extension TrackDetail {
    private func calculateDistance() -> Double {
        var list: [CLLocation] = []
        var distance = 0.0
        for index in 0..<(track.xCoords?.count ?? 0) {
            list.append(CLLocation(latitude: track.xCoords?[index] ?? 0, longitude: track.yCoords?[index] ?? 0))
        }
        for itemDx in 1..<list.count {
            distance += list[itemDx].distance(from: list[itemDx - 1])
        }
        return distance
    }

    private func elapsedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        let startDate = dateFormatter.date(from: track.startDate) ?? Date()
        let endDate = dateFormatter.date(from: track.endDate) ?? Date()
        return formatter.string(from: startDate.distance(to: endDate)) ?? ""
    }
}

#Preview {
    TrackDetail(track: .init(id: "123", name: "Track 123", startDate: "2024-02-18 15:04:01", endDate: "2024-02-18 15:08:01", tracking: false))
}
