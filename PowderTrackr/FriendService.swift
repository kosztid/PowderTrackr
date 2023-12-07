import Amplify
import Combine
import UIKit

public protocol FriendServiceProtocol: AnyObject {
    var friendListPublisher: AnyPublisher<Friendlist?, Never> { get }
    var friendRequestsPublisher: AnyPublisher<[FriendRequest], Never> { get }
    var friendPositionPublisher: AnyPublisher<Location?, Never> { get }
    var friendPositionsPublisher: AnyPublisher<[Location], Never> { get }

    func updateTracking(id: String) async
    func queryFriends() async
    func addFriend(request: FriendRequest) async
    func deleteFriend(friendlist: Friendlist) async
    func sendFriendRequest(recipient: String) async
    func queryFriendRequests() async
    func queryFriendLocations() async

}

final class FriendService {
    private let friendList: CurrentValueSubject<Friendlist?, Never> = .init(nil)
    private let friendRequests: CurrentValueSubject<[FriendRequest], Never> = .init([])
    private let friendPosition: CurrentValueSubject<Location?, Never> = .init(nil)
    private let friendPositions: CurrentValueSubject<[Location], Never> = .init([])
    private var cancellables: Set<AnyCancellable> = []
}

extension FriendService: FriendServiceProtocol {

    var friendPositionPublisher: AnyPublisher<Location?, Never> {
        friendPosition
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

    public func queryFriendRequests() async {
        do {
            let friendQueryResults = try await Amplify.API.query(request: .list(FriendRequest.self))

            let result = try friendQueryResults.get().elements

            var email = ""
            do {
                let attributes = try await Amplify.Auth.fetchUserAttributes()
                for attribute in attributes where attribute.key.rawValue == "email" {
                    email = attribute.value
                }
            } catch let error as APIError {
                print(error)
            }

            let currentFriendRequests = result.compactMap { item in
                if item.recipient == email { return item } else { return nil }
            }

            friendRequests.send(currentFriendRequests)
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

            let personalChat = PersonalChat(id: UUID().uuidString, participants: [user.userId, request.sender.id], messages: [])

            _ = try await Amplify.API.mutate(request: .create(personalChat))

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
}
