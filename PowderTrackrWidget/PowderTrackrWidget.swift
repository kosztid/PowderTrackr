import Factory
import SwiftUI
    import WidgetKit

    struct Provider: TimelineProvider {
        let data = Container.dataService()

        func placeholder(in context: Context) -> SimpleEntry {
            SimpleEntry(date: Date(), isTracking: data.isTracking(), speed: data.speed(), time: data.time(), distance: data.distance())
        }

        func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
            let entry = SimpleEntry(date: Date(), isTracking: data.isTracking(), speed: data.speed(), time: data.time(), distance: data.distance())
            completion(entry)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            var entries: [SimpleEntry] = []

            // Generate a timeline consisting of five entries an hour apart, starting from the current date.
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                _ = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
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

    struct PowderTrackrWidgetEntryView: View {
        let data = Container.dataService()
        var entry: Provider.Entry

        var body: some View {
            VStack {
                if data.isTracking() {
                    trackingView
                } else {
                    startupView
                }
            }
        }
        private var startupView: some View {
            VStack(spacing: .su16) {
                Text("Are you up?")
                    .foregroundColor(.darkSlateGray)
                    .bold()
                Text("Tap to start tracking")
                    .foregroundColor(.darkSlateGray)
                    .bold()
                    .multilineTextAlignment(.center)
            }
        }

        private var trackingView: some View {
            VStack {
                Spacer()
                HStack(spacing: .zero) {
                    HStack {
                        Image(systemName: "arrow.forward")
                            .resizable()
                            .frame(width: .su12, height: .su12)
                            .foregroundStyle(.warmDarkGray)
                        Text("Distance")
                            .foregroundColor(.warmDarkGray)
                            .font(.caption2)
                            .bold()
                    }
                    .foregroundStyle(Color.gray)
                    Spacer()
                    Text("\(String(format: "%.f", data.distance())) m")
                        .foregroundColor(.darkSlateGray)
                        .font(.caption2)
                        .bold()
                }
                spacedDivider
                HStack(spacing: .zero) {
                    HStack {
                        Image(systemName: "timer")
                            .resizable()
                            .frame(width: .su12, height: .su12)
                            .foregroundStyle(.warmDarkGray)
                        Text("Total time")
                            .foregroundColor(.warmDarkGray)
                            .font(.caption2)
                            .bold()
                    }
                    .foregroundStyle(Color.gray)
                    Spacer()
                    Text("\(String(format: "%.2f", data.time())) s")
                        .foregroundColor(.darkSlateGray)
                        .font(.caption)
                        .bold()
                }
                spacedDivider
                HStack(spacing: .zero) {
                    HStack {
                        Image(systemName: "speedometer")
                            .resizable()
                            .frame(width: .su12, height: .su12)
                            .foregroundStyle(.warmDarkGray)
                        Text("Avg speed")
                            .foregroundColor(.warmDarkGray)
                            .font(.caption2)
                            .bold()
                    }
                    .foregroundStyle(Color.gray)
                    Spacer()
                    Text("\(String(format: "%.2f", data.speed())) km/h")
                        .foregroundColor(.darkSlateGray)
                        .font(.caption)
                        .bold()
                }
                Spacer()
            }
            .padding()
        }

        private var spacedDivider: some View {
            VStack(spacing: .zero) {
                Spacer()
                Divider()
                    .padding(.horizontal, .su12)
                Spacer()
            }
        }
    }

    struct PowderTrackrWidget: Widget {
        let kind: String = "PowderTrackrWidget"

        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                if #available(iOS 17.0, *) {
                    PowderTrackrWidgetEntryView(entry: entry)
                        .preferredColorScheme(.light)
                        .containerBackground(.bluePrimary.opacity(0.35), for: .widget)
                } else {
                    PowderTrackrWidgetEntryView(entry: entry)
                        .preferredColorScheme(.light)
                        .background(.bluePrimary.opacity(0.35))
                }
            }
            .contentMarginsDisabled()
            .configurationDisplayName("PowderTrackr")
            .description("Track your skiing data")
        }
    }

    #Preview(as: .systemSmall) {
        PowderTrackrWidget()
    } timeline: {
        SimpleEntry(date: Date(), isTracking: true, speed: 100, time: 100, distance: 100)
    }
