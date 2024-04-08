import UIKit

public extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first(where: \.isKeyWindow)
    }
}
