import ActivityKit
import Foundation

public struct PowderTrackrWidgetAttributes: ActivityAttributes {
    public var name: String

    public struct ContentState: Codable, Hashable {
        public var distance: Double
        public var time: Double

        public init(distance: Double, time: Double) {
            self.distance = distance
            self.time = time
        }
    }

    public init(name: String) {
        self.name = name
    }
}
