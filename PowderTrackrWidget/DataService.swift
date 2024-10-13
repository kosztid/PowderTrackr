import Factory
import Foundation
import SwiftUI

public class DataService {
    @AppStorage("elapsedTime", store: UserDefaults(suiteName: "group.koszti.storedData")) private var elapsedTimeStorage: Double = 0.0
    @AppStorage("avgSpeed", store: UserDefaults(suiteName: "group.koszti.storedData")) private var avgSpeedStorage: Double = 0.0
    @AppStorage("distance", store: UserDefaults(suiteName: "group.koszti.storedData")) private var distanceStorage: Double = 0.0
    @AppStorage("isTracking", store: UserDefaults(suiteName: "group.koszti.storedData")) private var isTrackingStorage = false

    public func isTracking() -> Bool {
        isTrackingStorage
    }

    public func distance() -> Double {
        distanceStorage
    }

    public func time() -> Double {
        elapsedTimeStorage
    }

    public func speed() -> Double {
        avgSpeedStorage
    }
}
