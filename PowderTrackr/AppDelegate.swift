import AWSCognitoIdentityProvider
import GoogleMaps
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UIFont.registerFonts()
        let serviceConfiguration = AWSServiceConfiguration(region: .EUCentral1, credentialsProvider: nil)
        let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: "33uv3qc4u4msgqmrujbmq44n9i", clientSecret: nil, poolId: "eu-central-1_aiso5x2O8")
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: userPoolConfiguration, forKey: "UserPool")
        
        let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
        
        GMSServices.provideAPIKey("AIzaSyCkUwcWyQT54awQLcyN32pHdw35XoGPkEs")
        return true
    }
}

