import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil

    func startSession() {
        session?.delegate = self
        session?.activate()
    }

    // WCSessionDelegate methods...
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func sendMessage() {
        if let session = session, session.isReachable {
            session.sendMessage(["command": "startTracking"], replyHandler: nil) { error in
                print("Error sending start command to watch: \(error.localizedDescription)")
            }
        }
    }
}

