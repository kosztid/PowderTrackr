import Foundation
import WatchConnectivity

class WatchConnectivityProvider: NSObject, ObservableObject, WCSessionDelegate {
    @Published var receivedData: String = ""
    @Published var elapsedTime: Double = 0.0
    @Published var avgSpeed: Double = 0.0
    @Published var distance: Double = 0.0
    @Published var isTracking = false
    @Published var userID: String = ""

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sendUserId(_ id: String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["userid": id], replyHandler: nil) { error in
                print("Failed to send data: \(error.localizedDescription)")
            }
        }
    }

    func sendMetrics(elapsedTime: Double, avgSpeed: Double, distance: Double) {
        if WCSession.default.isReachable {
            let data: [String: Any] = [
                "elapsedTime": elapsedTime,
                "avgSpeed": avgSpeed,
                "distance": distance
            ]
            WCSession.default.sendMessage(data, replyHandler: nil) { error in
                print("Failed to send metrics: \(error.localizedDescription)")
            }
        }
    }

    func sendIsTracking(isTracking: Bool) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["isTracking": isTracking], replyHandler: nil) { error in
                print("Failed to send data: \(error.localizedDescription)")
            }
        }
    }

    // MARK: WCSessionDelegate Methods

    // Required to handle activation and any errors that may occur
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle activation of the session
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        }
    }

    // Optional: Implement to support iOS and watchOS session management
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session becoming inactive
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Handle session deactivation
        session.activate() // You may need to reactivate the session
    }
#endif

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            if let elapsedTime = message["elapsedTime"] as? Double {
                self.elapsedTime = elapsedTime
            }
            if let avgSpeed = message["avgSpeed"] as? Double {
                self.avgSpeed = avgSpeed
            }
            if let distance = message["distance"] as? Double {
                self.distance = distance
            }
            if let isTracking = message["isTracking"] as? Bool {
                self.isTracking = isTracking
            }
            if let id = message["userid"] as? String {
                self.userID = id
            }
        }
    }
}
