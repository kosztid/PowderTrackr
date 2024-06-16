import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), isTracking: data.isTracking(), speed: data.speed(), time: data.time(), distance: data.distance())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), isTracking: data.isTracking(), speed: data.speed(), time: data.time(), distance: data.distance())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: Date(), isTracking: data.isTracking(), speed: data.speed(), time: data.time(), distance: data.distance())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    
    let isTracking: Bool
    let speed: Double
    let time: Double
    let distance: Double
}

struct PowderTrackrWidgetEntryView : View {
    let data = DataService()
    var entry: Provider.Entry

    var body: some View {
        if data.isTracking() {
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
                        .frame(width: .su10, height: .su10)
                    Text("distance")
                        .font(.caption2)
                }
                .foregroundStyle(Color.gray)
                Spacer()
                Text("\(String(format: "%.f", data.distance())) m")
                    .font(.caption2)
                    .bold()
            }
            Divider()
                .padding(.horizontal, .su12)
            HStack(spacing: .zero) {
                HStack {
                    Image(systemName: "timer")
                        .resizable()
                        .frame(width: .su10, height: .su10)
                    Text("total time")
                        .font(.caption2)
                }
                .foregroundStyle(Color.gray)
                Spacer()
                Text("\(String(format: "%.2f", data.time())) s")
                    .font(.caption)
                    .bold()
            }
            Divider()
                .padding(.horizontal, .su12)
            HStack(spacing: .zero) {
                HStack {
                    Image(systemName: "speedometer")
                        .resizable()
                        .frame(width: .su10, height: .su10)
                    Text("avg speed")
                        .font(.caption2)
                }
                .foregroundStyle(Color.gray)
                Spacer()
                Text("\(String(format: "%.2f", data.speed())) km/h")
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
    SimpleEntry(date: Date(), isTracking: true, speed: 100, time: 100, distance: 100)
}
