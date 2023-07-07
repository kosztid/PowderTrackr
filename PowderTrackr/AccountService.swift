import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import Combine
import UIKit

public protocol AccountServiceProtocol: AnyObject {
    var isSignedInPublisher: AnyPublisher<Bool, Never> { get }
    var userPublisher: AnyPublisher<AuthUser?, Never> { get }
    var emailPublisher: AnyPublisher<String?, Never> { get }

    func login() async
    func signUp(_ username: String, _ email: String, _ password: String) async
    func signIn(_ username: String, _ password: String) async
    func confirmSignUp(with confirmationCode: String, _ username: String, _ password: String) async
    func resetPassword(username: String) async
    func changePassword(oldPassword: String, newPassword: String) async
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String) async

    func createFriendList() async
    func createUserTrackedPaths() async
    func createLocation(xCoord: String, yCoord: String) async
    func updateLocation(xCoord: String, yCoord: String) async
    func queryLocation() async

    func signOut() async
    func confirm() async

    func getUser() async
}

final class AccountService {
    private let isSignedIn: CurrentValueSubject<Bool, Never> = .init(false)
    private let user: CurrentValueSubject<AuthUser?, Never> = .init(nil)
    private let email: CurrentValueSubject<String?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = []
    private var username: String = ""
    
    init() {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()

                self.isSignedIn.send(session.isSignedIn)
            } catch {
                print("Fetch auth session failed with error - \(error)")
            }
        }
    }
}

extension AccountService: AccountServiceProtocol {
    var userPublisher: AnyPublisher<AuthUser?, Never> {
        user
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var emailPublisher: AnyPublisher<String?, Never> {
        email
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var isSignedInPublisher: AnyPublisher<Bool, Never> {
        isSignedIn
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func getUser() async {
        do {
            let currentUser = try await Amplify.Auth.getCurrentUser()
            user.send(currentUser)

            var currentEmail = ""
            do {
                let attributes = try await Amplify.Auth.fetchUserAttributes()
                for attribute in attributes where attribute.key.rawValue == "email" {
                    currentEmail = attribute.value
                }
                email.send(currentEmail)
            } catch let error as APIError {
                print(error)
            }
        } catch let error as APIError {
            print("Failed to return user: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    public func createFriendList() async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let friendlist = Friendlist(id: user.userId, friends: [])
            guard let data = friendlist.data else { return }
            _ = try await Amplify.API.mutate(request: .create(data))
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    public func resetPassword(username: String) async {
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: username)
            switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    print("Reset completed")
            }
        } catch let error as AuthError {
            print("Reset password failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func changePassword(oldPassword: String, newPassword: String) async {
        do {
            try await Amplify.Auth.update(oldPassword: oldPassword, to: newPassword)
            print("Change password succeeded")
        } catch let error as AuthError {
            print("Change password failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func confirmResetPassword(
        username: String,
        newPassword: String,
        confirmationCode: String
    ) async {
        do {
            try await Amplify.Auth.confirmResetPassword(
                for: username,
                with: newPassword,
                confirmationCode: confirmationCode
            )
            print("Password reset confirmed")
        } catch let error as AuthError {
            print("Reset password failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    public func createLocation(xCoord: String, yCoord: String) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let location = Location(id: "location_" + user.userId, name: user.username, xCoord: xCoord, yCoord: yCoord)
            guard let data = location.data else { return }
            let result = try await Amplify.API.mutate(request: .create(data))
            let parsedData = try result.get()
            print("Successfully create location: \(parsedData)")
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    public func updateLocation(xCoord: String, yCoord: String) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let location = Location(id: "location_" + user.userId, name: user.username, xCoord: xCoord, yCoord: yCoord)
            guard let data = location.data else { return }
            _ = try await Amplify.API.mutate(request: .update(data))
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func queryLocation() async {
        do {
            let queryResult = try await Amplify.API.query(request: .list(CurrentPosition.self))

            let result = try queryResult.get().elements.map { cPos in
                Location(from: cPos)
            }

            print(result)
        } catch {
            print("Can not retrieve location : error \(error)")
        }
    }

    func createUserTrackedPaths() async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let trackedPaths = TrackedPathModel(id: user.userId, tracks: [])
            guard let data = trackedPaths.data else { return }
            _ = try await Amplify.API.mutate(request: .create(data))
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    public func login() async {
        do {
            let signInResult = try await Amplify.Auth.signInWithWebUI(presentationAnchor: UIApplication.shared.windows.first)
            if signInResult.isSignedIn {
                print("Sign in succeeded")
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    public func signIn(_ username: String, _ password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(username: username, password: password)
            if signInResult.isSignedIn {
                print("Sign in succeeded")
                isSignedIn.send(true)
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    private func signInFirstTime(_ username: String, _ password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(username: username, password: password)
            if signInResult.isSignedIn {
                print("Sign in succeeded")
                isSignedIn.send(true)
                await self.createLocation(xCoord: "0", yCoord: "0")
                await self.createFriendList()
                await self.createUserTrackedPaths()
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func signUp(_ username: String, _ email: String, _ password: String) async {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: username,
                password: password,
                options: options
            )

            self.username = username

            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId)))")
            } else {
                print("Signup Complete")
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func confirmSignUp(with confirmationCode: String, _ username: String, _ password: String) async {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: self.username,
                confirmationCode: confirmationCode
            )
            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")

            await self.signInFirstTime(username, password)
        } catch let error as AuthError {
            print("An error occurred while confirming sign up \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }

    func confirm() async {
        await self.createLocation(xCoord: "0", yCoord: "0")
        await self.createFriendList()
        await self.createUserTrackedPaths()
    }

    // signout
    public func signOut() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        switch signOutResult {
        case .complete:
            print("Successfully signed out")
            isSignedIn.send(false)

        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            if let hostedUIError = hostedUIError {
                print("HostedUI error  \(String(describing: hostedUIError))")
            }

            if let globalSignOutError = globalSignOutError {
                print("GlobalSignOut error  \(String(describing: globalSignOutError))")
            }

            if let revokeTokenError = revokeTokenError {
                print("Revoke token error  \(String(describing: revokeTokenError))")
            }

        case .failed(let error):
            print("SignOut failed with \(error)")
        }
    }
}
