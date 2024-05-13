import AWSCognitoIdentityProvider
import Combine
import Foundation

public enum AccountServiceModel {
    public struct AccountData {
        public let userID: String
    }
}

public protocol AccountServiceProtocol: AnyObject {
    var isSignedInPublisher: AnyPublisher<Bool, Never> { get }
    var userPublisher: AnyPublisher<AWSCognitoIdentityUser?, Never> { get }
    var emailPublisher: AnyPublisher<String?, Never> { get }
    
    func initUser()
    func signUp(_ username: String, _ email: String, _ password: String) async
    func signIn(_ username: String, _ password: String) -> AnyPublisher<AccountServiceModel.AccountData, Error>
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
}

final class AccountService {
    private var accessToken: String?
    private var userID: String = UserDefaults.standard.string(forKey: "id") ?? ""
    private var userName: String = UserDefaults.standard.string(forKey: "name") ?? ""
    
    private let isSignedIn: CurrentValueSubject<Bool, Never> = .init(false)
    private let user: CurrentValueSubject<AWSCognitoIdentityUser?, Never> = .init(nil)
    private let email: CurrentValueSubject<String?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = []
    private var username: String = ""
    
    private let cognitoClientId = "33uv3qc4u4msgqmrujbmq44n9i"
    private var identityProvider: AWSCognitoIdentityProvider
    
    init() {
        let pool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        self.identityProvider = AWSCognitoIdentityProvider(forKey: "UserPool")
        self.user.value = pool?.currentUser()
        reload()
    }
    
    func reload() {
        if self.user.value?.username == self.userName {
            self.isSignedIn.send(true)
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
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set("", forKey: "id")
            UserDefaults.standard.set("", forKey: "name")
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
    
    public func createFriendList() {
        let friendlist = Friendlist(id: userID, friends: [])
        guard let data = friendlist.data else { return }
        
        DefaultAPI.userfriendListsPut(userfriendList: data) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else { }
        }
    }
    
    func resetPassword(username: String) async {
        let forgotPasswordRequest = AWSCognitoIdentityProviderForgotPasswordRequest()!
            forgotPasswordRequest.username = username
            forgotPasswordRequest.clientId = "33uv3qc4u4msgqmrujbmq44n9i"
        
        do {
            let response = try await self.identityProvider.forgotPassword(forgotPasswordRequest)
            print("Reset password initiated: \(response)")
        } catch {
            print("Error resetting password: \(error)")
        }
    }
    
    func changePassword(oldPassword: String, newPassword: String) async {
        do {
            let changePasswordResult = try await self.user.value?.changePassword(oldPassword, proposedPassword: newPassword)
            print("Password changed: \(String(describing: changePasswordResult))")
        } catch {
            print("Error changing password: \(error)")
        }
    }
    
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String) async {
        // Create the request object for confirming a forgotten password
        let confirmForgotPasswordRequest = AWSCognitoIdentityProviderConfirmForgotPasswordRequest()!
        confirmForgotPasswordRequest.username = username
        confirmForgotPasswordRequest.password = newPassword
        confirmForgotPasswordRequest.confirmationCode = confirmationCode
        confirmForgotPasswordRequest.clientId = "33uv3qc4u4msgqmrujbmq44n9i" // Insert your App Client ID here

        do {
            // Call the confirmForgotPassword method on the Cognito identity provider
            let confirmationResult = try await self.identityProvider.confirmForgotPassword(confirmForgotPasswordRequest)
            print("Password reset confirmed: \(confirmationResult)")
        } catch {
            print("Error confirming password reset: \(error)")
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
        if userID == "" {
            return
        }
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
        if userID == "" {
            return
        }
        let leaderBoard = LeaderBoard(id: userID, name: userName, distance: distance, totalTimeInSeconds: time)
        
        DefaultAPI.leaderBoardsPut(leaderBoard: leaderBoard) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    func signIn(_ username: String, _ password: String) -> AnyPublisher<AccountServiceModel.AccountData, Error> {
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
                        self.fetchUserAttributes(user: user!, promise: promise)
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
    
    private func fetchUserAttributesReload(user: AWSCognitoIdentityUser) {
        user.getDetails().continueWith { [weak self] task in
            DispatchQueue.main.async {
                if let error = task.error {
                    print("Failed to fetch user attributes: \(error)")
                } else if let userDetails = task.result {
                    let attributes = userDetails.userAttributes ?? []

                    let email = attributes.first(where: { $0.name == "email" })?.value
                    let userID = attributes.first(where: { $0.name == "sub" })?.value
                    
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(userID, forKey: "id")
                    UserDefaults.standard.set(user.username, forKey: "name")

                    self?.email.send(email)
                    self?.user.send(user)
                    self?.isSignedIn.send(true)

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


    private func fetchUserAttributes(user: AWSCognitoIdentityUser, promise: @escaping (Result<AccountServiceModel.AccountData, Error>) -> Void) {
        user.getDetails().continueWith { [weak self] task in
            DispatchQueue.main.async {
                if let error = task.error {
                    promise(.failure(error))
                } else if let userDetails = task.result {
                    let attributes = userDetails.userAttributes ?? []
                    let email = attributes.first(where: { $0.name == "email" })?.value
                    let userID = attributes.first(where: { $0.name == "sub" })?.value
                    
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(userID, forKey: "id")
                    UserDefaults.standard.set(userDetails.username, forKey: "name")
                    
                    self?.email.send(email)
                    self?.userName = userDetails.username ?? ""
                    self?.userID = userID ?? ""
                    self?.isSignedIn.send(true)
                    
                    promise(.success(AccountServiceModel.AccountData(userID: userID!)))
                }
            }
            return nil
        }
    }

    
    public func initUser() {
        createLocation(xCoord: "0", yCoord: "0")
        createFriendList()
        createUserTrackedPaths()
        createLeaderBoardEntity()
    }
    
    // TODO: ENDPOINT CREATE USER ENTRIES
    private func signInFirstTime(_ username: String, _ password: String) -> AnyPublisher<AccountServiceModel.AccountData, Error> {
        return Future<AccountServiceModel.AccountData, Error> { promise in
            Task {
                do {
                    let authRequest = AWSCognitoIdentityProviderInitiateAuthRequest()!
                    authRequest.authFlow = .userPasswordAuth
                    authRequest.clientId = "33uv3qc4u4msgqmrujbmq44n9i"
                    authRequest.authParameters = ["USERNAME": username, "PASSWORD": password]
                    
                    let authResponse = try await self.identityProvider.initiateAuth(authRequest)
                    if let authenticationResult = authResponse.authenticationResult, let idToken = authenticationResult.idToken {
                        self.updateSignInStatus(isSignedIn: true)
                        
                        let userId = self.decodeIdToken(idToken: idToken)
                        let userEmail = self.extractClaim(fromIdToken: idToken, claimKey: "email")
                        
                        UserDefaults.standard.set(userEmail, forKey: "email")
                        UserDefaults.standard.set(userId, forKey: "id")
                        UserDefaults.standard.set(username, forKey: "name")
                        
                        self.initUser()
                        
                        promise(.success(AccountServiceModel.AccountData(userID: userId)))
                    } else {
                        promise(.failure(NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Authentication failed"])))
                    }
                } catch {
                    promise(.failure(error))
                    print("Sign in failed \(error)")
                }
            }
        }
        .eraseToAnyPublisher()
    }

    
    func signUp(_ username: String, _ email: String, _ password: String) async {
        // Create the request object
        let signUpRequest = AWSCognitoIdentityProviderSignUpRequest()!
        signUpRequest.username = username
        signUpRequest.password = password
        signUpRequest.clientId = "33uv3qc4u4msgqmrujbmq44n9i" // Insert your Cognito User Pool App Client ID here

        var attributes = [AWSCognitoIdentityProviderAttributeType]()
        let emailAttribute = AWSCognitoIdentityProviderAttributeType()
        emailAttribute?.name = "email"
        emailAttribute?.value = email
        attributes.append(emailAttribute!)
        
        signUpRequest.userAttributes = attributes
        

        do {
            // Perform the signup operation
            let signUpResponse = try await identityProvider.signUp(signUpRequest)
            if signUpResponse.userConfirmed?.boolValue == true {
                // If user is automatically confirmed, update sign in status
                updateSignInStatus(isSignedIn: true)
            } else {
                // Handle other cases, e.g., requiring email confirmation
                print("Sign up successful, please confirm your email.")
            }
        } catch {
            print("Error signing up: \(error)")
        }
    }
    
    func confirmSignUp(with confirmationCode: String, _ username: String, _ password: String) async {
        let confirmSignUpRequest = AWSCognitoIdentityProviderConfirmSignUpRequest()!
        confirmSignUpRequest.username = username
        confirmSignUpRequest.confirmationCode = confirmationCode
        confirmSignUpRequest.clientId = "33uv3qc4u4msgqmrujbmq44n9i"  // Replace with your actual Cognito User Pool App Client ID

        do {
            // Perform the confirmation operation
            let confirmationResult = try await identityProvider.confirmSignUp(confirmSignUpRequest)
            print("Sign up confirmation successful.")
            // If confirmation was successful, you might want to automatically sign in the user
            signInFirstTime(username, password)
        } catch {
            print("Error confirming sign up: \(error)")
        }
    }


    
    func signOut() {
        self.user.value?.signOut()
        updateSignInStatus(isSignedIn: false)
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
