import Amplify
import Combine
import UIKit

public protocol FriendServiceProtocol: AnyObject {
    var friendListPublisher: AnyPublisher<Friendlist?, Never> { get }
    var friendRequestsPublisher: AnyPublisher<[FriendRequest], Never> { get }
    var friendPositionPublisher: AnyPublisher<Location?, Never> { get }
    var friendPositionsPublisher: AnyPublisher<[Location], Never> { get }
    var networkErrorPublisher: AnyPublisher<ToastModel?, Never> { get }
    
    func updateTracking(id: String)
    func queryFriends()
    func addFriend(request: FriendRequest)
    func deleteFriend(friend: Friend)
    func sendFriendRequest(recipient: String) -> Future<Void, Error>
    func queryFriendRequests()
    func queryFriendLocations()
    func getUsers() -> Future<[User], Error>
    func getAddableUsers() -> Future<[User], Error>
}

final class FriendService {
    private let userID: String = UserDefaults.standard.string(forKey: "id") ?? ""
    private let userName: String = UserDefaults.standard.string(forKey: "name") ?? ""
    private let userEmail: String = UserDefaults.standard.string(forKey: "email") ?? ""
    private let friendList: CurrentValueSubject<Friendlist?, Never> = .init(nil)
    private let friendRequests: CurrentValueSubject<[FriendRequest], Never> = .init([])
    private let friendPosition: CurrentValueSubject<Location?, Never> = .init(nil)
    private let friendPositions: CurrentValueSubject<[Location], Never> = .init([])
    private let networkError: CurrentValueSubject<ToastModel?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = []
}

extension FriendService: FriendServiceProtocol {
    var networkErrorPublisher: AnyPublisher<ToastModel?, Never> {
        networkError
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
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
    
    func updateTracking(id: String) {
        var friends = friendList.value?.friends
        
        let friendDx = friends?.firstIndex { friend in
            friend.id == id
        }
        
        guard let index = friendDx else { return }
        
        friends?[index].isTracking.toggle()
        
        let friendlist = Friendlist(id: userID, friends: friends)
        guard let data = friendlist.data else { return }
        
        DefaultAPI.userfriendListsPut(userfriendList: data) { data, error in
            if let error = error {
                self.networkError.send(.init(title: "An issue occured while updating tracking", type: .error))
                print("Error: \(error)")
            } else {
                
            }
        }
    }
    
    public func queryFriendRequests() {
        DefaultAPI.friendRequestsGet { data, error in
            if let error = error {
                self.networkError.send(.init(title: "An issue occured while getting your friend requests", type: .error))
                print("Error: \(error)")
            } else {
                let currentFriendRequests = data?.compactMap { item in
                    if item.recipient == self.userID { return item } else { return nil }
                }
                guard let currentFriendRequests else { return }
                self.friendRequests.send(currentFriendRequests)
            }
        }
    }
    
    func queryFriends() {
        DefaultAPI.userfriendListsGet { data, error in
            if let error = error {
                self.networkError.send(.init(title: "An issue occured while loading your friends", type: .error))
                print("Error: \(error)")
            } else {
                let currentFriendList = data?.first { item in
                    item.id == self.userID
                }
                guard let currentFriendList else { return }
                self.friendList.send(Friendlist(from: currentFriendList))
            }
        }
    }
    
    public func addFriend(request: FriendRequest) {
        var friends = self.friendList.value?.friends
        
        friends?.append(request.sender)
        
        let friendlist = Friendlist(id: userID, friends: friends)
        guard let data = friendlist.data else { return }
        DefaultAPI.userfriendListsPut(userfriendList: data) { data, error in
            if let error = error {
                self.networkError.send(.init(title: "An issue occured while adding your friend", type: .error))
                print("Error: \(error)")
            } else {
                DefaultAPI.userfriendListsGet { data, error in
                    if let error = error {
                        self.networkError.send(.init(title: "An issue occured while adding your friend", type: .error))
                        print("Error: \(error)")
                    } else {
                        var senderFriends: [Friend] = []
                        
                        senderFriends = data?.first { item in
                            item.id == request.sender.id
                        }?.friends ?? []
                        
                        senderFriends.append(Friend(id: self.userID, name: self.userName, isTracking: true))
                        
                        let senderFriendlist = Friendlist(id: request.sender.id, friends: senderFriends)
                        
                        guard let data = friendlist.data else { return }
                        
                        DefaultAPI.userfriendListsPut(userfriendList: data) { data, error in
                            if let error = error {
                                self.networkError.send(.init(title: "An issue occured while adding your friend", type: .error))
                                print("Error: \(error)")
                            } else {
                            }
                        }
                        
                        guard let senderData = senderFriendlist.data else { return }
                        
                        DefaultAPI.userfriendListsPut(userfriendList: senderData) { data, error in
                            if let error = error {
                                self.networkError.send(.init(title: "An issue occured while adding your friend", type: .error))
                                print("Error: \(error)")
                            } else {
                            }
                        }
                        
                        let personalChat = PersonalChat(id: UUID().uuidString, participants: [self.userID, request.sender.id], messages: [])
                        
                        DefaultAPI.personalChatsPut(personalChat: personalChat) { data, error in
                            if let error = error {
                                self.networkError.send(.init(title: "An issue occured while adding your friend", type: .error))
                                print("Error: \(error)")
                            } else {
                                self.queryFriends()
                                self.queryFriendRequests()
                            }
                        }
                    }
                }
            }
        }
        
        DefaultAPI.friendRequestsIdDelete(id: request.id) { data, error in
            if let error = error {
                self.networkError.send(.init(title: "An issue occured while accepting your friendrequest", type: .error))
                print("Error: \(error)")
            } else {
            }
        }
    }
    
    public func deleteFriend(friend: Friend)  {
        var friends = self.friendList.value?.friends
        friends?.removeAll { $0.id == friend.id }
        let friendList = friendList.value
        friendList?.friends = friends
        guard let data = friendList?.data else { return }
        DefaultAPI.userfriendListsPut(userfriendList: data ) { data, error in
            if let error = error {
                self.networkError.send(.init(title: "An issue occured while deleting your friend", type: .error))
                print("Error: \(error)")
            } else {
                self.friendList.send(friendList)
            }
        }
    }
    
    public func sendFriendRequest(recipient: String) -> Future<Void, Error> {
        let request = FriendRequest(
            senderEmail: userEmail,
            sender: Friend(
                id: userID,
                name: userName,
                isTracking: true
            ),
            recipient: recipient
        )
        return Future { promise in
            DefaultAPI.friendRequestsPut(friendRequest: request) { data, error in
                if let error = error {
                    self.networkError.send(.init(title: "An issue occured while sending your request", type: .error))
                    print("Error: \(error)")
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    func queryFriendLocations() {
        queryFriends()
        var userIdList: [String] = []
        userIdList = self.friendList.value?.friends?.compactMap { friendlist in
            if friendlist.isTracking {
                return ("location_" + friendlist.id)
            } else {
                return nil
            }
        } ?? []
        DefaultAPI.currentPositionsGet { data, error in
            if let error = error {
                self.networkError.send(.init(title: "An issue occured while getting your friend's locations", type: .error))
                print("Error: \(error)")
            } else {
                let result = data?.compactMap { cPos in
                    if userIdList.contains(cPos.id) {
                        return Location(from: cPos)
                    } else {
                        return nil
                    }
                }
                guard let result else { return }
                self.friendPositions.send(result)
            }
        }
    }
    
    func getUsers() -> Future<[User], Error>  {
        return Future<[User], Error> { promise in
            DefaultAPI.usersGet { data, error in
                if let error = error {
                    print(error)
                    self.networkError.send(.init(title: "An issue occured while getting users", type: .error))
                } else {
                    let result = data?.compactMap { user in
                        return user
                    }
                    promise(.success(result ?? []))
                }
            }
        }
    }
    
    func getAddableUsers() -> Future<[User], Error>  {
        return Future<[User], Error> { promise in
            DefaultAPI.usersIdGet(id: self.userID) { data, error in
                if let error = error {
                    print(error)
                    self.networkError.send(.init(title: "An issue occured while getting users", type: .error))
                } else {
                    let result = data?.compactMap { user in
                        return user
                    }
                    promise(.success(result ?? []))
                }
            }
        }
    }
}
