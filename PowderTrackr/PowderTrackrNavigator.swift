import FlowStacks
import SwiftUI

public enum PowderTrackrScreen {
    case account
    case tabBar
}

protocol PowderTrackrViewNavigatorProtocol {
    func navigateToAccount()
}

public struct PowderTrackrNavigator: Navigator {
    @State var routes: Routes<PowderTrackrScreen>
    
    public var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .tabBar: ViewFactory.powderTrackrView(navigator: self)
            case .account: ViewFactory.profileNavigator(navigateBack: navigateBack)
            }
        }
    }
    
    public init() {
        self.routes = [.root(.tabBar, embedInNavigationView: true)]
    }
}

extension PowderTrackrNavigator: PowderTrackrViewNavigatorProtocol {
    func navigateToAccount() {
        routes.presentCover(.account)
    }
    
    func navigateBack() {
        routes.dismiss()
    }
}
