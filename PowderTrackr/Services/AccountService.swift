import AWSCognitoIdentityProvider
import Combine
import Foundation
import SwiftUI

public enum AccountServiceModel {
    public struct AccountData {
        public let userID: String
    }
}

public protocol AccountServiceProtocol: AnyObject {
    var isSignedInPublisher: AnyPublisher<Bool, Never> { get }
    var userPublisher: AnyPublisher<AWSCognitoIdentityUser?, Never> { get }
    var emailPublisher: AnyPublisher<String?, Never> { get }
    
    func register(_ username: String, _ email: String, _ password: String) -> AnyPublisher<Void, Error>
    func signIn(_ username: String, _ password: String, firstTime: Bool) -> AnyPublisher<AccountServiceModel.AccountData, Error>
    func confirmSignUp(with confirmationCode: String, _ username: String, _ password: String) -> AnyPublisher<Void, Error>
    func resetPassword(username: String) -> AnyPublisher<Void, Error>
    func changePassword(oldPassword: String, newPassword: String) -> AnyPublisher<Void, Error>
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String) -> AnyPublisher<Void, Error>
    func updateLeaderboard(time: Double, distance: Double)

    func updateLocation(xCoord: String, yCoord: String)
    
    func signOut() async
}

final class AccountService {
    var accessToken: String?
    @AppStorage("id", store: UserDefaults(suiteName: "group.koszti.PowderTrackr")) var userID: String = ""
    @AppStorage("name", store: UserDefaults(suiteName: "group.koszti.PowderTrackr")) var userName: String = ""
    
    let isSignedIn: CurrentValueSubject<Bool, Never> = .init(false)
    let user: CurrentValueSubject<AWSCognitoIdentityUser?, Never> = .init(nil)
    let email: CurrentValueSubject<String?, Never> = .init(nil)
    var cancellables: Set<AnyCancellable> = []
    var username: String = ""
    
    private let cognitoClientId = "33uv3qc4u4msgqmrujbmq44n9i"
    private var identityProvider: AWSCognitoIdentityProvider
    private var watchConnectivityProvider: WatchConnectivityProvider
    
    init() {
        self.watchConnectivityProvider = WatchConnectivityProvider()
        let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        self.identityProvider = AWSCognitoIdentityProvider(forKey: "UserPool")
        self.user.value = pool?.currentUser()
        reload()
    }
    
    func reload() {
        if self.user.value?.username == self.userName {
            self.isSignedIn.send(true)
            watchConnectivityProvider.sendUserId(userID)
        }
    }
    private func updateSignInStatus(isSignedIn: Bool) {
        self.isSignedIn.send(isSignedIn)
        if isSignedIn {
            guard let accessToken = self.accessToken else {
                print("Access token is unavailable.")
                return
            }
            
            let request = AWSCognitoIdentityProviderGetUserRequest()!
            request.accessToken = accessToken
            
            self.identityProvider.getUser(request).continueWith { (task: AWSTask<AWSCognitoIdentityProviderGetUserResponse>) -> AnyObject? in
                if let error = task.error {
                    print("Failed to fetch user attributes: \(error)")
                    DispatchQueue.main.async {
                        self.email.send(nil)
                    }
                } else if let getUserResponse = task.result {
                    let email = getUserResponse.userAttributes?.first { $0.name == "email" }?.value
                    DispatchQueue.main.async {
                        self.email.send(email)
                    }
                }
                return nil
            }
        } else {
            UserDefaults(suiteName: "group.koszti.PowderTrackr")?.set("", forKey: "email")
            UserDefaults(suiteName: "group.koszti.PowderTrackr")?.set("", forKey: "id")
            UserDefaults(suiteName: "group.koszti.PowderTrackr")?.set("", forKey: "name")
            watchConnectivityProvider.sendUserId("")
        }
    }
}

extension AccountService: AccountServiceProtocol {
    var userPublisher: AnyPublisher<AWSCognitoIdentityUser?, Never> {
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
    
    func resetPassword(username: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            if self == nil {
                promise(.failure(NSError(domain: "ResetPasswordError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }

            let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
            let user = pool?.getUser(username)
            user?.forgotPassword().continueWith { task -> Any? in
                DispatchQueue.main.async {
                    if let error = task.error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                        print("Reset password initiated successfully.")
                    }
                }
                return nil
            }
        }
        .eraseToAnyPublisher()
    }

    
    func changePassword(oldPassword: String, newPassword: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "ChangePasswordError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            guard let user = self.user.value else {
                promise(.failure(NSError(domain: "ChangePasswordError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user"])))
                return
            }

            user.changePassword(oldPassword, proposedPassword: newPassword).continueWith { task -> Any? in
                DispatchQueue.main.async {
                    if let error = task.error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                        print("Password changed successfully.")
                    }
                }
                return nil
            }
        }
        .eraseToAnyPublisher()
    }

    
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard self != nil else {
                promise(.failure(NSError(domain: "ConfirmResetPasswordError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }

            let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
            let user = pool?.getUser(username)
            user?.confirmForgotPassword(confirmationCode, password: newPassword).continueWith { task -> Any? in
                DispatchQueue.main.async {
                    if let error = task.error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                        print("Password reset confirmed successfully.")
                    }
                }
                return nil
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signIn(_ username: String, _ password: String, firstTime: Bool = false) -> AnyPublisher<AccountServiceModel.AccountData, Error> {
        return Future<AccountServiceModel.AccountData, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
            let user = pool?.getUser(username)
            user?.getSession(username, password: password, validationData: nil).continueWith { task -> Any? in
                DispatchQueue.main.async {
                    if let error = task.error {
                        promise(.failure(error))
                    } else if let session = task.result {
                        self.accessToken = session.idToken?.tokenString
                        self.fetchUserAttributes(user: user!, firstTime: firstTime, promise: promise)
                    }
                }
                return nil
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func reloadCurrentUser() {
        guard let currentUser = self.user.value else {
            self.isSignedIn.send(false)
            return
        }
        
        currentUser.getSession().continueWith { [weak self] task in
            DispatchQueue.main.async {
                if let error = task.error {
                    print("Error retrieving session: \(error)")
                    self?.isSignedIn.send(false)
                } else if let session = task.result, self!.isValidToken(session.idToken?.tokenString) {
                    self?.isSignedIn.send(true)
                    self?.fetchUserAttributesReload(user: currentUser)
                } else {
                    self?.isSignedIn.send(false)
                }
            }
            return nil
        }
    }
    
    // TODO: ENDPOINT CREATE USER ENTRIES
    
    func register(_ username: String, _ email: String, _ password: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "SignUpError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
            var attributes = [AWSCognitoIdentityUserAttributeType]()
            
            let emailAttribute = AWSCognitoIdentityUserAttributeType(name: "email", value: email)
            attributes.append(emailAttribute)
            
            pool?.signUp(username, password: password, userAttributes: attributes, validationData: nil).continueWith { task -> Any? in
                DispatchQueue.main.async {
                    if let error = task.error {
                        promise(.failure(error))
                    } else if let result = task.result {
                        if result.user.confirmedStatus == .confirmed {
                            // User is confirmed
                            self.updateSignInStatus(isSignedIn: true)
                            promise(.success(()))
                        } else {
                            // User needs to confirm their email
                            print("Sign up successful, please confirm your email.")
                            promise(.success(()))
                        }
                    }
                }
                return nil
            }
        }
        .eraseToAnyPublisher()
    }
    
    func confirmSignUp(with confirmationCode: String, _ username: String, _ password: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "ConfirmSignUpError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }

            let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
            let user = pool?.getUser(username)
            
            user?.confirmSignUp(confirmationCode).continueWith { task -> Any? in
                DispatchQueue.main.async {
                    if let error = task.error {
                        promise(.failure(error))
                    } else {
                        print("Sign up confirmation successful.")
                        self.signIn(username, password, firstTime: true).sink(receiveCompletion: { completion in
                            switch completion {
                            case .failure(let error):
                                promise(.failure(error))
                            case .finished:
                                promise(.success(()))
                            }
                        }, receiveValue: { _ in })
                        .store(in: &self.cancellables)
                    }
                }
                return nil
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signOut() {
        self.user.value?.signOut()
        updateSignInStatus(isSignedIn: false)
    }
}

private extension AccountService {
    func initUser(email: String) {
        addUser(email: email)
    }
    
    private func fetchUserAttributesReload(user: AWSCognitoIdentityUser) {
        user.getDetails().continueWith { [weak self] task in
            DispatchQueue.main.async {
                if let error = task.error {
                    print("Failed to fetch user attributes: \(error)")
                } else if let userDetails = task.result {
                    guard let self else { return }
                    let attributes = userDetails.userAttributes ?? []

                    let email = attributes.first(where: { $0.name == "email" })?.value
                    let userID = attributes.first(where: { $0.name == "sub" })?.value
                    
                    UserDefaults(suiteName: "group.koszti.PowderTrackr")?.set(email, forKey: "email")
                    UserDefaults(suiteName: "group.koszti.PowderTrackr")?.set(userID, forKey: "id")
                    UserDefaults(suiteName: "group.koszti.PowderTrackr")?.set(user.username, forKey: "name")

                    self.email.send(email)
                    self.user.send(user)
                    self.isSignedIn.send(true)
                    self.watchConnectivityProvider.sendUserId(userID ?? "")

                    print("User attributes updated successfully: Email: \(String(describing: email)), UserID: \(String(describing: userID))")
                }
            }
            return nil
        }
    }


    private func isValidToken(_ token: String?) -> Bool {
        guard let token = token, let jwtToken = try? decodeJWT(token: token) else {
            return false
        }

        if let exp = jwtToken["exp"] as? Double {
            return Date().timeIntervalSince1970 < exp
        }

        return false
    }

    private func decodeJWT(token: String) throws -> [String: Any] {
        let segments = token.components(separatedBy: ".")
        guard segments.count > 1 else {
            throw NSError(domain: "JWTError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid token"])
        }
        
        let base64String = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        var base64 = base64String
        let length = Double(base64.lengthOfBytes(using: .utf8)) / 4.0
        if floor(length) != length {
            let paddingLength = 4 - (base64.lengthOfBytes(using: .utf8) % 4)
            base64 += String(repeating: "=", count: paddingLength)
        }

        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            throw NSError(domain: "JWTError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid base64"])
        }
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let json = jsonObject as? [String: Any] else {
            throw NSError(domain: "JWTError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
        }
        
        return json
    }


    private func fetchUserAttributes(user: AWSCognitoIdentityUser, firstTime: Bool = false, promise: @escaping (Result<AccountServiceModel.AccountData, Error>) -> Void) {
        user.getDetails().continueWith { [weak self] task in
            DispatchQueue.main.async {
                if let error = task.error {
                    promise(.failure(error))
                } else if let userDetails = task.result {
                    guard let self else { return }
                    let attributes = userDetails.userAttributes ?? []
                    let email = attributes.first(where: { $0.name == "email" })?.value
                    let userID = attributes.first(where: { $0.name == "sub" })?.value
                    
                    UserDefaults(suiteName: "group.koszti.PowderTrackr")?.set(email, forKey: "email")
                    UserDefaults(suiteName: "group.koszti.PowderTrackr")?.set(userID, forKey: "id")
                    UserDefaults(suiteName: "group.koszti.PowderTrackr")?.set(userDetails.username, forKey: "name")
                    
                    self.email.send(email)
                    self.userName = userDetails.username ?? ""
                    self.userID = userID ?? ""
                    self.isSignedIn.send(true)
                    self.watchConnectivityProvider.sendUserId(userID ?? "")
                    
                    if firstTime {
                        self.initUser(email: email ?? "")
                    }
                    
                    promise(.success(AccountServiceModel.AccountData(userID: userID!)))
                }
            }
            return nil
        }
    }
    
    // Helper function to decode the ID token and extract user ID
    private func decodeIdToken(idToken: String) -> String {
        let segments = idToken.components(separatedBy: ".")
        guard segments.count > 1 else { return "" }

        // Decode the payload part from base64URL to Data
        if let payloadData = decodeJWTPart(segments[1]) {
            // Convert Data to Dictionary to extract the 'sub' claim
            if let json = try? JSONSerialization.jsonObject(with: payloadData, options: []),
               let payloadDict = json as? [String: Any],
               let userId = payloadDict["sub"] as? String {
                return userId
            }
        }
        return ""
    }

    // Decode base64URL encoded JWT part to Data
    private func decodeJWTPart(_ base64URLString: String) -> Data? {
        var base64 = base64URLString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        // Padding with = to ensure the base64 string's length is a multiple of 4
        while base64.count % 4 != 0 {
            base64.append("=")
        }

        return Data(base64Encoded: base64)
    }

    private func extractClaim(fromIdToken idToken: String, claimKey: String) -> String {
        let segments = idToken.components(separatedBy: ".")
        guard segments.count > 1, let payloadData = decodeJWTPart(segments[1]),
              let json = try? JSONSerialization.jsonObject(with: payloadData, options: []),
              let payloadDict = json as? [String: Any] else { return "" }

        return payloadDict[claimKey] as? String ?? ""
    }
}
