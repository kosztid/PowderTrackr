import SwiftUI
import WidgetKit

@main
struct PowderTrackrWidgetBundle: WidgetBundle {
    var body: some Widget {
        PowderTrackrWidget()
        PowderTrackrWidgetLiveActivity()
    }
}
