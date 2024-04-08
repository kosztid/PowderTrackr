import Amplify
import AWSCognitoAuthPlugin
import GoogleMaps
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UIFont.registerFonts()
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
        } catch {
            print("Could not initialize Amplify: \(error)")
        }
        GMSServices.provideAPIKey("AIzaSyCkUwcWyQT54awQLcyN32pHdw35XoGPkEs")
        return true
    }
}
