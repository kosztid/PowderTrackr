import SwiftUI

@main
struct PowderTrackrWatch_Watch_AppApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
