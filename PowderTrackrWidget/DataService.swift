import Foundation
import SwiftUI

struct DataService {
    @AppStorage("elapsedTime", store: UserDefaults(suiteName: "group.koszti.storedData")) private var elapsedTimeStorage: Double = 0.0
    @AppStorage("avgSpeed", store: UserDefaults(suiteName: "group.koszti.storedData")) private var avgSpeedStorage: Double = 0.0
    @AppStorage("distance", store: UserDefaults(suiteName: "group.koszti.storedData")) private var distanceStorage: Double = 0.0
    @AppStorage("isTracking", store: UserDefaults(suiteName: "group.koszti.storedData")) private var isTrackingStorage: Bool = false
    
    func isTracking() -> Bool {
        return isTrackingStorage
    }
    
    func distance() -> Double {
        return distanceStorage
    }    
    
    func time() -> Double {
        return elapsedTimeStorage
    }  
    
    func speed() -> Double {
        return avgSpeedStorage
    }
}
