import ActivityKit
import Factory
import SwiftUI
import WidgetKit

struct PowderTrackrWidgetLiveActivity: Widget {
    let data = Container.dataService()

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PowderTrackrWidgetAttributes.self) { context in
            VStack {
                Text("Tracking: \(context.attributes.name)")
                    .font(.headline)
                Text("Distance: \(data.distance(), specifier: "%.2f") km") // Using data.distance() directly
                    .font(.subheadline)
                Text("Time: \(data.time(), specifier: "%.0f") seconds") // Using data.time() directly
                    .font(.subheadline)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { _ in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Distance:")
                    Text("\(data.distance(), specifier: "%.2f") km")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Time:")
                    Text("\(data.time(), specifier: "%.0f") s")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Keep going!")
                        .font(.caption)
                }
            } compactLeading: {
                Text("")
            } compactTrailing: {
                Text("\(data.distance(), specifier: "%.2f") km")
            } minimal: {
                Text("")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
