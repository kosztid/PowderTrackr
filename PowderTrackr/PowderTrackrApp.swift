import Factory
import SwiftUI

typealias Navigator = View

@main
struct PowderTrackrApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ViewFactory.powderTrackrNavigator()
        }
    }

    init() {
    }
}
