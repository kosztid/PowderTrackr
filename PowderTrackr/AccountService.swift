import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import Combine
import UIKit

public protocol AccountServiceProtocol: AnyObject {
    var isSignedInPublisher: AnyPublisher<Bool, Never> { get }
    var userPublisher: AnyPublisher<AuthUser?, Never> { get }
    var emailPublisher: AnyPublisher<String?, Never> { get }
    var friendListPublisher: AnyPublisher<Friendlist?, Never> { get }
    var friendRequestsPublisher: AnyPublisher<[FriendRequest], Never> { get }
    var friendPositionPublisher: AnyPublisher<Location?, Never> { get }
    var friendPositionsPublisher: AnyPublisher<[Location], Never> { get }
    var trackedPathPublisher: AnyPublisher<TrackedPathModel?, Never> { get }

    func login() async
    func signUp(_ username: String, _ email: String, _ password: String) async
    func signIn(_ username: String, _ password: String) async
    func confirmSignUp(with confirmationCode: String, _ username: String, _ password: String) async

    func queryFriends() async
    func createFriendList() async
    func addFriend(request: FriendRequest) async
    func deleteFriend(friendlist: Friendlist) async
    func sendFriendRequest(recipient: String) async
    func queryFriendRequests() async
    func queryFriendLocation(userId: String) async
    func queryFriendLocations() async

    func createLocation(xCoord: String, yCoord: String) async
    func updateLocation(xCoord: String, yCoord: String) async
    func queryLocation() async

    func createUserTrackedPaths() async
    func updateTrackedPath(_ trackedPath: TrackedPath) async
    func updateTrack(_ trackedPath: TrackedPath) async
    func removeTrackedPath(_ trackedPath: TrackedPath) async
    func queryTrackedPaths() async

    func signOut() async
    func confirm() async
    func updateTracking(id: String) async

    func getUser() async
}

final class AccountService {
    private let isSignedIn: CurrentValueSubject<Bool, Never> = .init(false)
    private let user: CurrentValueSubject<AuthUser?, Never> = .init(nil)
    private let email: CurrentValueSubject<String?, Never> = .init(nil)
    private let friendList: CurrentValueSubject<Friendlist?, Never> = .init(nil)
    private let friendRequests: CurrentValueSubject<[FriendRequest], Never> = .init([])
    private let friendPosition: CurrentValueSubject<Location?, Never> = .init(nil)
    private let friendPositions: CurrentValueSubject<[Location], Never> = .init([])
    private let trackedPathModel: CurrentValueSubject<TrackedPathModel?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = []
    private var username: String = ""

    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure()

            Task {
                do {
                    let session = try await Amplify.Auth.fetchAuthSession()

                    // let's update UserData and the UI
                    self.isSignedIn.send(session.isSignedIn)
                } catch {
                    print("Fetch auth session failed with error - \(error)")
                }
            }
        } catch {
            print("Could not initialize Amplify: \(error)")
        }
    }
    //
    //
    //    func deleteLocation(location: Location) async {
    //
    //        do {
    //            guard let data = location.data else { return }
    //            let result = try await Amplify.API.mutate(request: .delete(data))
    //            switch result {
    //            case .success(let data):
    //                print("Successfully deleted note: \(data)")
    //            case .failure(let error):
    //                print("Got failed result with \(error.errorDescription)")
    //            }
    //        } catch {
    //            print("Got failed result with error \(error)")
    //        }
    //    }
}

extension AccountService: AccountServiceProtocol {
    var friendPositionPublisher: AnyPublisher<Location?, Never> {
        friendPosition
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

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

    var friendPositionsPublisher: AnyPublisher<[Location], Never> {
        friendPositions
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var friendRequestsPublisher: AnyPublisher<[FriendRequest], Never> {
        friendRequests
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var friendListPublisher: AnyPublisher<Friendlist?, Never> {
        friendList
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var isSignedInPublisher: AnyPublisher<Bool, Never> {
        isSignedIn
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var trackedPathPublisher: AnyPublisher<TrackedPathModel?, Never> {
        trackedPathModel
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

    public func addFriend(request: FriendRequest) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let friendQueryResults = try await Amplify.API.query(request: .list(UserfriendList.self))
            let friendQueryResultsMapped = try friendQueryResults.get().elements.map { list in
                Friendlist(from: list)
            }

            var friends = friendQueryResultsMapped.first { item in
                item.id == user.userId
            }?.friends

            friends?.append(request.sender)

            let friendlist = Friendlist(id: user.userId, friends: friends)
            guard let data = friendlist.data else { return }
            _ = try await Amplify.API.mutate(request: .update(data))
            _ = try await Amplify.API.mutate(request: .delete(request))

            var senderFriends = friendQueryResultsMapped.first { item in
                item.id == request.sender.id
            }?.friends

            senderFriends?.append(Friend(id: user.userId, name: user.username, isTracking: true))

            let senderFriendlist = Friendlist(id: request.sender.id, friends: senderFriends)
            guard let senderData = senderFriendlist.data else { return }
            _ = try await Amplify.API.mutate(request: .update(senderData))

            await queryFriends()
            await queryFriendRequests()
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    public func deleteFriend(friendlist: Friendlist) async {
        do {
            let data = UserfriendList(
                id: friendlist.id,
                friends: friendlist.friends,
                createdAt: friendlist.data?.createdAt,
                updatedAt: friendlist.data?.updatedAt
            )
            _ = try await Amplify.API.mutate(request: .update(data))
            await queryFriends()
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    public func sendFriendRequest(recipient: String) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            var email = ""
            do {
                let attributes = try await Amplify.Auth.fetchUserAttributes()
                for attribute in attributes where attribute.key.rawValue == "email" {
                    email = attribute.value
                }
            } catch let error as APIError {
                print(error)
            }

            let request = FriendRequest(
                senderEmail: email,
                sender: Friend(
                    id: user.userId,
                    name: user.username,
                    isTracking: true
                ),
                recipient: recipient
            )

            _ = try await Amplify.API.mutate(request: .create(request))
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    public func queryFriendRequests() async {
        do {
            let friendQueryResults = try await Amplify.API.query(request: .list(FriendRequest.self))

            let result = try friendQueryResults.get().elements

            var email = ""
            do {
                let attributes = try await Amplify.Auth.fetchUserAttributes()
                for attribute in attributes where attribute.key.rawValue == "email" {
                    email = attribute.value
                    print(email)
                }
            } catch let error as APIError {
                print(error)
            }

            print("Result", result)
            let currentFriendRequests = result.compactMap { item in
                if item.recipient == email { return item } else { return nil }
            }

            friendRequests.send(currentFriendRequests)
            print(currentFriendRequests)
        } catch {
            print("Can not retrieve friendrequests : error \(error)")
        }
    }

    func queryFriends() async {
        do {
            let friendQueryResults = try await Amplify.API.query(request: .list(UserfriendList.self))

            let user = try await Amplify.Auth.getCurrentUser()

            let result = try friendQueryResults.get().elements.map { list in
                Friendlist(from: list)
            }

            let currentFriendList = result.first { item in
                item.id == user.userId
            }

            friendList.send(currentFriendList)
            print(result)
        } catch {
            print("Can not retrieve friends : error \(error)")
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

    func queryFriendLocations() async {
        do {
            await queryFriends()
            var userIdList: [String] = []
            userIdList = self.friendList.value?.friends?.compactMap { friendlist in
                if friendlist.isTracking {
                    return ("location_" + friendlist.id)
                } else {
                    return nil
                }
            } ?? []

            let queryResult = try await Amplify.API.query(request: .list(CurrentPosition.self))

            let result = try queryResult.get().elements.compactMap { cPos in
                if userIdList.contains(cPos.id) {
                    return Location(from: cPos)
                } else {
                    return nil
                }
            }

            self.friendPositions.send(result)
        } catch {
            print("Can not retrieve friendlocations : error \(error)")
        }
    }

    func queryFriendLocation(userId: String) async {
        do {
            let queryResult = try await Amplify.API.query(request: .list(CurrentPosition.self))

            let result = try queryResult.get().elements.map { cPos in
                Location(from: cPos)
            }

            _ = result.first { loc in
                loc.id == ("location_" + userId)
            }
        } catch {
            print("Can not retrieve friendlocation : error \(error)")
        }
    }

    func updateTracking(id: String) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let friendQueryResults = try await Amplify.API.query(request: .list(UserfriendList.self))
            let friendQueryResultsMapped = try friendQueryResults.get().elements.map { list in
                Friendlist(from: list)
            }

            var friends = friendQueryResultsMapped.first { item in
                item.id == user.userId
            }?.friends

            var friendDx = friends?.firstIndex { friend in
                friend.id == id
            }

            guard let index = friendDx else { return }

            friends?[index].isTracking.toggle()

            let friendlist = Friendlist(id: user.userId, friends: friends)
            guard let data = friendlist.data else { return }
            _ = try await Amplify.API.mutate(request: .update(data))
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
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

    func updateTrackedPath(_ trackedPath: TrackedPath) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            let tracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(from: item)
            }

            var tracks = tracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            tracks?.append(trackedPath)

            let trackModel = TrackedPathModel(id: user.userId, tracks: tracks)
            guard let data = trackModel.data else { return }
            _ = try await Amplify.API.mutate(request: .update(data))

            await queryTrackedPaths()
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func updateTrack(_ trackedPath: TrackedPath) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            let tracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(from: item)
            }

            var tracks = tracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks
            let id = tracks?.firstIndex { $0.id == trackedPath.id } ?? 0
            tracks?[id] = trackedPath

            let trackModel = TrackedPathModel(id: user.userId, tracks: tracks)
            guard let data = trackModel.data else { return }
            _ = try await Amplify.API.mutate(request: .update(data))

            await queryTrackedPaths()
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func removeTrackedPath(_ trackedPath: TrackedPath) async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            let tracksQueryResults = try await Amplify.API.query(request: .list(UserTrackedPaths.self))
            let tracksQueryResultsMapped = try tracksQueryResults.get().elements.map { item in
                TrackedPathModel(from: item)
            }

            var tracks = tracksQueryResultsMapped.first { item in
                item.id == user.userId
            }?.tracks

            tracks?.removeAll { $0.id == trackedPath.id }

            let trackModel = TrackedPathModel(id: user.userId, tracks: tracks)
            guard let data = trackModel.data else { return }
            _ = try await Amplify.API.mutate(request: .update(data))

            await queryTrackedPaths()
        } catch let error as APIError {
            print("Failed to create note: \(error)")
        } catch {
            print("Unexpected error while calling create API : \(error)")
        }
    }

    func queryTrackedPaths() async {
        do {
            let queryResult = try await Amplify.API.query(request: .list(UserTrackedPaths.self))

            let user = try await Amplify.Auth.getCurrentUser()

            let result = try queryResult.get().elements.map { model in
                TrackedPathModel(from: model)
            }

            let currentPaths = result.first { $0.id == user.userId }

            trackedPathModel.send(currentPaths)
        } catch {
            print("Can not retrieve friendlocation : error \(error)")
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
