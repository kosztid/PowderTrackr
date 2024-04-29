import ActivityKit
import WidgetKit
import SwiftUI

struct PowderTrackrWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
    }

    var name: String
}

struct PowderTrackrWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PowderTrackrWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PowderTrackrWidgetAttributes {
    fileprivate static var preview: PowderTrackrWidgetAttributes {
        PowderTrackrWidgetAttributes(name: "World")
    }
}

extension PowderTrackrWidgetAttributes.ContentState {
    fileprivate static var smiley: PowderTrackrWidgetAttributes.ContentState {
        PowderTrackrWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PowderTrackrWidgetAttributes.ContentState {
         PowderTrackrWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PowderTrackrWidgetAttributes.preview) {
   PowderTrackrWidgetLiveActivity()
} contentStates: {
    PowderTrackrWidgetAttributes.ContentState.smiley
    PowderTrackrWidgetAttributes.ContentState.starEyes
}
