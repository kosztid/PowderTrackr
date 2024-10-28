import ActivityKit
import Factory
import SwiftUI
import WidgetKit

struct PowderTrackrWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PowderTrackrWidgetAttributes.self) { context in
            VStack(alignment: .leading) {
                Text("WORKOUT")
                    .font(.caption)
                    .foregroundColor(.warmDarkGray)

                Spacer()

                HStack {
                    VStack(alignment: .leading) {
                        Text("\(String(format: "%.f", context.state.distance))")
                            .font(.system(size: .su36, weight: .bold, design: .rounded))
                            .foregroundColor(.blueSecondary)
                        Text("m")
                            .font(.title2)
                            .foregroundColor(.bluePrimary)
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("\(String(format: "%.2f", context.state.time))")
                            .font(.system(size: .su36, weight: .bold, design: .rounded))
                            .foregroundColor(.blueSecondary)
                        Text("s")
                            .font(.title2)
                            .foregroundColor(.bluePrimary)
                    }
                }

                Spacer()

                Text("Tracking: \(context.attributes.name)")
                    .font(.body)
                    .foregroundColor(.warmDarkGray)
            }
            .padding()
            .background(Color.softWhite)
            .activityBackgroundTint(Color.warmGray)
            .activitySystemActionForegroundColor(Color.green)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Text(context.attributes.name)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.blueSecondary)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Distance")
                                    .font(.caption)
                                    .foregroundColor(.warmDarkGray)
                                Text("\(String(format: "%.f", context.state.distance)) m")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.blueSecondary)
                            }
                            .padding(.leading)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Time")
                                    .font(.caption)
                                    .foregroundColor(.warmDarkGray)
                                Text("\(String(format: "%.2f", context.state.time)) s")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.blueSecondary)
                            }
                            .padding(.trailing)
                        }
                    }
                }
            } compactLeading: {
                Text("\(String(format: "%.f", context.state.distance)) m")
                    .font(.caption)
                    .foregroundColor(.blueSecondary)
            } compactTrailing: {
                Text("\(String(format: "%.2f", context.state.time)) s")
                    .font(.caption)
                    .foregroundColor(.blueSecondary)
            } minimal: {
                Text("\(String(format: "%.2f", context.state.time)) s")
                    .font(.caption2)
                    .foregroundColor(.blueSecondary)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct RaceLiveActivity_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PowderTrackrWidgetAttributes(name: "Skiing Session")
                .previewContext(
                    PowderTrackrWidgetAttributes.ContentState(
                        distance: 1_234, time: 123
                    ),
                    viewKind: .content
                )

            PowderTrackrWidgetAttributes(name: "Skiing Session")
                .previewContext(
                    PowderTrackrWidgetAttributes.ContentState(
                        distance: 1_234, time: 123
                    ),
                    viewKind: .dynamicIsland(.expanded)
                )
            PowderTrackrWidgetAttributes(name: "Skiing Session")
                .previewContext(
                    PowderTrackrWidgetAttributes.ContentState(
                        distance: 1_234, time: 123
                    ),
                    viewKind: .dynamicIsland(.minimal)
                )
            PowderTrackrWidgetAttributes(name: "Skiing Session")
                .previewContext(
                    PowderTrackrWidgetAttributes.ContentState(
                        distance: 1_234, time: 123
                    ),
                    viewKind: .dynamicIsland(.compact)
                )
        }
    }
}
