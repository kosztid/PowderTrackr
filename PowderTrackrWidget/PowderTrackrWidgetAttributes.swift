import ActivityKit
import Foundation

public struct PowderTrackrWidgetAttributes: ActivityAttributes {
    public var name: String

    public struct ContentState: Codable, Hashable {
        public var name: String

        public init(name: String) {
            self.name = name
        }
    }

    public init(name: String) {
        self.name = name
    }
}
