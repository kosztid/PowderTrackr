import SwiftUI

struct TrackCell: View {
    let track: TrackedPath
    var body: some View {
        HStack {
            Text(track.name)
        }
    }
}

#Preview {
    TrackCell(track: .init(id: "123", name: "Track 123", startDate: "2024-02-18 15:04:01", endDate: "2024-02-18 15:08:01", tracking: false))
}
