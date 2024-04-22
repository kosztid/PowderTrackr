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
    var entry: Provider.Entry

    var body: some View {
        VStack {
            //                HStack(spacing: .su4) {
            //                    Text("\(String(format: "%.f", 12310.123)) m")
            //                        .textStyle(.bodyBold)
            //                    HStack {
            //                        Image(systemName: "arrow.forward")
            //                            .frame(minHeight: .su20)
            //                        Text("distance")
            //                            .textStyle(.body)
            //                    }
            //                    .foregroundStyle(Color.warmDarkGray)
            //                }
            //                Divider()
            //                    .padding(.horizontal, .su12)
            //                HStack(spacing: .su4) {
            //                    Text("\(String(format: "%.2f", 1123.132)) s")
            //                        .textStyle(.bodyBold)
            //                    HStack {
            //                        Image(systemName: "timer")
            //                        Text("total time")
            //                            .textStyle(.body)
            //                    }
            //                    .foregroundStyle(Color.warmDarkGray)
            //                }
            //                Divider()
            //                    .padding(.horizontal, .su12)
            //                HStack(spacing: .su4) {
            //                    Text("\(String(format: "%.2f", 100.123)) km/h")
            //                        .textStyle(.bodyBold)
            //                    HStack {
            //                        Image(systemName: "speedometer")
            //                        Text("avg speed")
            //                            .textStyle(.body)
            //                    }
            //                    .foregroundStyle(Color.warmDarkGray)
            //                }
            //            }
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
