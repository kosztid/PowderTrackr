import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import Combine
import UIKit

public protocol AccountServiceProtocol: AnyObject {
    var isSignedInPublisher: AnyPublisher<Bool, Never> { get }
    var userPublisher: AnyPublisher<AuthUser?, Never> { get }
    var emailPublisher: AnyPublisher<String?, Never> { get }
    
    func initUser()
    func login() async
    func signUp(_ username: String, _ email: String, _ password: String) async
    func signIn(_ username: String, _ password: String) async
    func confirmSignUp(with confirmationCode: String, _ username: String, _ password: String) async
    func resetPassword(username: String) async
    func changePassword(oldPassword: String, newPassword: String) async
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String) async
    func updateLeaderboard(time: Double, distance: Double)
    
    func createFriendList()
    func createUserTrackedPaths()
    func createLocation(xCoord: String, yCoord: String)
    func updateLocation(xCoord: String, yCoord: String)
    
    func signOut() async
    func confirm() async
}

final class AccountService {
    private let userID: String = UserDefaults.standard.string(forKey: "id") ?? ""
    private let userName: String = UserDefaults.standard.string(forKey: "name") ?? ""
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
    
    public func createFriendList() {
        let friendlist = Friendlist(id: userID, friends: [])
        guard let data = friendlist.data else { return }
        
        DefaultAPI.userfriendListsPut(userfriendList: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else { }
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
    
    public func createLocation(xCoord: String, yCoord: String) {
        let location = Location(id: "location_" + userID, name: userName, xCoord: xCoord, yCoord: yCoord)
        guard let data = location.data else { return }
        
        DefaultAPI.currentPositionsPut(currentPosition: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    public func updateLocation(xCoord: String, yCoord: String) {
        let location = Location(id: "location_" + userID, name: userName, xCoord: xCoord, yCoord: yCoord)
        guard let data = location.data else { return }
        
        DefaultAPI.currentPositionsPut(currentPosition: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    func createUserTrackedPaths() {
        let trackedPaths = TrackedPathModel(id: userID, tracks: [])
        guard let data = trackedPaths.data else { return }
        DefaultAPI.userTrackedPathsPut(userTrackedPaths: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    func createLeaderBoardEntity() {
        let leaderBoard = LeaderBoard(id: userID, name: userName, distance: 0.0, totalTimeInSeconds: 0.0)
        
        DefaultAPI.leaderBoardsPut(leaderBoard: leaderBoard) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    func updateLeaderboard(time: Double, distance: Double) {
        let leaderBoard = LeaderBoard(id: userID, name: userName, distance: distance, totalTimeInSeconds: time)
        
        DefaultAPI.leaderBoardsPut(leaderBoard: leaderBoard) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
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
                let user = try await Amplify.Auth.getCurrentUser()
                let attributes = try await Amplify.Auth.fetchUserAttributes()
                for attribute in attributes where attribute.key.rawValue == "email" {
                    UserDefaults.standard.set(attribute.value, forKey: "email")
                }
                UserDefaults.standard.set(user.userId, forKey: "id")
                UserDefaults.standard.set(user.username, forKey: "name")
            }
        } catch let error as AuthError {
            print("Sign in failed \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    public func initUser() {
        createLocation(xCoord: "0", yCoord: "0")
        createFriendList()
        createUserTrackedPaths()
        createLeaderBoardEntity()
    }
    
    // TODO: ENDPOINT CREATE USER ENTRIES
    private func signInFirstTime(_ username: String, _ password: String) async {
        do {
            let signInResult = try await Amplify.Auth.signIn(username: username, password: password)
            if signInResult.isSignedIn {
                print("Sign in succeeded")
                isSignedIn.send(true)
                let user = try await Amplify.Auth.getCurrentUser()
                let attributes = try await Amplify.Auth.fetchUserAttributes()
                for attribute in attributes where attribute.key.rawValue == "email" {
                    UserDefaults.standard.set(attribute.value, forKey: "email")
                }
                
                UserDefaults.standard.set(user.userId, forKey: "id")
                UserDefaults.standard.set(user.username, forKey: "name")
                
                
                self.createLocation(xCoord: "0", yCoord: "0")
                self.createFriendList()
                self.createUserTrackedPaths()
                self.createLeaderBoardEntity()
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
    
    func confirm() {
        self.createLocation(xCoord: "0", yCoord: "0")
        self.createFriendList()
        self.createUserTrackedPaths()
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
