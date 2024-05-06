import WatchConnectivity

class WatchSessionDelegate: NSObject, WCSessionDelegate {
    @Published var started: Bool = false
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let command = message["command"] as? String, command == "startTracking" {
            DispatchQueue.main.async {
                self.started = true
            }
        }
    }
}
