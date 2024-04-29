import WidgetKit
import SwiftUI

@main
struct PowderTrackrWidgetBundle: WidgetBundle {
    var body: some Widget {
        PowderTrackrWidget()
        PowderTrackrWidgetLiveActivity()
    }
}
