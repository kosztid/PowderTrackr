import FlowStacks
import Foundation
import SwiftUI

public enum ProfileScreen {
    case profile
    case login
    case register
    case verify
}

protocol ProfileViewNavigatorProtocol {
    func login()
    func register()
}

protocol RegisterViewNavigatorProtocol {
    func registered()
}

protocol RegisterVerificationViewNavigatorProtocol {
    func verified()
}

protocol LoginViewNavigatorProtocol {
    func loggedIn()
}

public struct ProfileNavigator: Navigator {
    @State var routes: Routes<ProfileScreen>

    public var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .profile:
                ViewFactory.profileView(navigator: self)
            case .login:
                ViewFactory.loginView(navigator: self)
            case .register:
                ViewFactory.registerView(navigator: self)
            case .verify:
                ViewFactory.registerVerificationView(navigator: self)
            }
        }
    }

    public init(
    ) {
        self.routes = [.root(.profile, embedInNavigationView: true)]
    }
}

extension ProfileNavigator: ProfileViewNavigatorProtocol {
    func login() {
        routes.push(.login)
    }

    func register() {
        routes.push(.register)
    }
}

extension ProfileNavigator: LoginViewNavigatorProtocol {
    func loggedIn() {
        routes.popToRoot()
    }
}

extension ProfileNavigator: RegisterViewNavigatorProtocol {
    func registered() {
        routes.push(.verify)
    }
}

extension ProfileNavigator: RegisterVerificationViewNavigatorProtocol {
    func verified() {
        routes.popToRoot()
    }
}
