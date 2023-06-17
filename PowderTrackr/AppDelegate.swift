import GoogleMaps
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCkUwcWyQT54awQLcyN32pHdw35XoGPkEs")
        return true
    }
}
