import FlowStacks
import Foundation
import SwiftUI

public enum ProfileScreen {
    case profile
    case login
    case register
    case verify(username: String, password: String)
    case resetPassword
    case resetPasswordConfirmation(username: String)
    case updatePassword
}

protocol ProfileViewNavigatorProtocol {
    func dismissScreen()
    func login()
    func register()
    func updatePassword()
}

protocol RegisterViewNavigatorProtocol {
    func registered(username: String, password: String)
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


protocol ChangePasswordViewNavigatorProtocol {
    func changeButtonTapped()
    func navigateBack()
}


protocol ResetPasswordVerificationNavigatorProtocol {
    func verifyButtonTapped()
    func navigateBack()
}

public struct ProfileNavigator: Navigator {
    @State var routes: Routes<ProfileScreen>
    var dismissNavigator: () -> Void

    public var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .profile:
                ViewFactory.profileView(navigator: self)
            case .login:
                ViewFactory.loginView(navigator: self)
            case .register:
                ViewFactory.registerView(navigator: self)
            case .verify(let username, let password):
                ViewFactory.registerVerificationView(
                    navigator: self,
                    model: .init(username: username, password: password)
                )
            case .resetPassword:
                ViewFactory.resetPasswordView(navigator: self)
            case .resetPasswordConfirmation(let username):
                ViewFactory.confirmResetPasswordView(navigator: self, username: username)
            case .updatePassword:
                ViewFactory.updatePasswordView(navigator: self)
            }
        }
    }

    public init(
        dismissNavigator: @escaping () -> Void
    ) {
        self.routes = [.root(.profile, embedInNavigationView: true)]
        self.dismissNavigator = dismissNavigator
    }
}

extension ProfileNavigator: ProfileViewNavigatorProtocol {
    func dismissScreen() {
        dismissNavigator()
    }
    func updatePassword() {
        routes.push(.updatePassword)
    }
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
    func registered(username: String, password: String) {
        routes.push(.verify(username: username, password: password))
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

extension ProfileNavigator: ChangePasswordViewNavigatorProtocol {
    func changeButtonTapped() {
        routes.goBackToRoot()
    }
}

extension ProfileNavigator: ResetPasswordVerificationNavigatorProtocol {
    func verifyButtonTapped() {
        routes.popToRoot()
    }
}
