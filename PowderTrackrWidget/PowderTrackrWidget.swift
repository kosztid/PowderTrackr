import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct PowderTrackrWidgetEntryView : View {
    @AppStorage("elapsedTime") var elapsedTimeStorage: Double = 0.0
    @AppStorage("avgSpeed") var avgSpeedStorage: Double = 0.0
    @AppStorage("distance") var distanceStorage: Double = 0.0
    @AppStorage("isTracking") var isTrackingStorage: Bool = false
    
    var entry: Provider.Entry

    var body: some View {
        if isTrackingStorage {
            trackingView
        } else {
            startupView
        }
    }
    private var startupView: some View {
        VStack {
            Text("Are you up?")
                .font(.caption2)
            Text("Tap to start tracking")
                .font(.caption2)
        }
    }
    
    private var trackingView: some View {
        VStack {
            HStack(spacing: .zero) {
                HStack {
                    Image(systemName: "arrow.forward")
                        .resizable()
                        .frame(width: 10, height: 10)
                    Text("distance")
                        .font(.caption2)
                }
                .foregroundStyle(Color.gray)
                Spacer()
                Text("\(String(format: "%.f", distanceStorage)) m")
                    .font(.caption2)
                    .bold()
            }
            Divider()
                .padding(.horizontal, 12)
            HStack(spacing: .zero) {
                HStack {
                    Image(systemName: "timer")
                        .resizable()
                        .frame(width: 10, height: 10)
                    Text("total time")
                        .font(.caption2)
                }
                .foregroundStyle(Color.gray)
                Spacer()
                Text("\(String(format: "%.2f", elapsedTimeStorage)) s")
                    .font(.caption)
                    .bold()
            }
            Divider()
                .padding(.horizontal, 12)
            HStack(spacing: .zero) {
                HStack {
                    Image(systemName: "speedometer")
                        .resizable()
                        .frame(width: 10, height: 10)
                    Text("avg speed")
                        .font(.caption2)
                }
                .foregroundStyle(Color.gray)
                Spacer()
                Text("\(String(format: "%.2f", avgSpeedStorage)) km/h")
                    .font(.caption)
                    .bold()
            }
        }
    }
}

struct PowderTrackrWidget: Widget {
    let kind: String = "PowderTrackrWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PowderTrackrWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                PowderTrackrWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    PowderTrackrWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
