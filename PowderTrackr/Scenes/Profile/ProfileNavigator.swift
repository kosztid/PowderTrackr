import FlowStacks
import Foundation
import SwiftUI

public enum ProfileScreen {
    case profile
    case login
    case register
    case verify
    case resetPassword
    case resetPasswordConfirmation(username: String)
}

protocol ProfileViewNavigatorProtocol {
    func login()
    func register()
}

protocol RegisterViewNavigatorProtocol {
    func registered()
    func dismiss()
}

protocol RegisterVerificationViewNavigatorProtocol {
    func verified()
}

protocol LoginViewNavigatorProtocol {
    func loggedIn()
    func navigateToResetPassword()
    func dismiss()
}

protocol ResetPasswordViewNavigatorProtocol {
    func resetButtonTapped(username: String)
    func navigateBack()
}

protocol ResetPasswordVerificationNavigatorProtocol {
    func verifyButtonTapped()
    func navigateBack()
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
            case .resetPassword:
                ViewFactory.resetPasswordView(navigator: self)
            case .resetPasswordConfirmation(let username):
                ViewFactory.confirmResetPasswordView(navigator: self, username: username)
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
    func navigateToResetPassword() {
        routes.push(.resetPassword)
    }

    func loggedIn() {
        routes.popToRoot()
    }

    func dismiss() {
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

extension ProfileNavigator: ResetPasswordViewNavigatorProtocol {
    func navigateBack() {
        routes.pop(1)
    }

    func resetButtonTapped(username: String) {
        routes.push(.resetPasswordConfirmation(username: username))
    }
}

extension ProfileNavigator: ResetPasswordVerificationNavigatorProtocol {
    func verifyButtonTapped() {
        routes.popToRoot()
    }
}
