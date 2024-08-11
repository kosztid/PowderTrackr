// Generated using Sourcery 2.2.5 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import AWSCognitoIdentityProvider
import Combine
import ExyteChat


@testable import PowderTrackr















public final class AccountServiceProtocolMock: AccountServiceProtocol {
private let lock = NSLock()
    public var isSignedInPublisher: AnyPublisher<Bool, Never> {
        get { return underlyingIsSignedInPublisher }
        set(value) { underlyingIsSignedInPublisher = value }
    }
    public var underlyingIsSignedInPublisher: AnyPublisher<Bool, Never>!
    public var userPublisher: AnyPublisher<AWSCognitoIdentityUser?, Never> {
        get { return underlyingUserPublisher }
        set(value) { underlyingUserPublisher = value }
    }
    public var underlyingUserPublisher: AnyPublisher<AWSCognitoIdentityUser?, Never>!
    public var emailPublisher: AnyPublisher<String?, Never> {
        get { return underlyingEmailPublisher }
        set(value) { underlyingEmailPublisher = value }
    }
    public var underlyingEmailPublisher: AnyPublisher<String?, Never>!

public init() {}

    //MARK: - register

    public var registerCallsCount = 0
    public var registerCalled: Bool {
        registerCallsCount > 0
    }
    public var registerReceivedArguments: (username: String, email: String, password: String)?
    public var registerReceivedInvocations: [(username: String, email: String, password: String)] = []
    public var registerReturnValue: AnyPublisher<Void, Error>!
    public var registerStub: ((String, String, String) -> AnyPublisher<Void, Error>)?

    public func register(_ username: String, _ email: String, _ password: String) -> AnyPublisher<Void, Error> {
        lock.withLock {
            registerCallsCount += 1
        registerReceivedArguments = (username: username, email: email, password: password)
        registerReceivedInvocations.append((username: username, email: email, password: password))
        }
        if let registerStub = registerStub {
            return registerStub(username, email, password)
        } else {
            return registerReturnValue
        }
    }

    //MARK: - signIn

    public var signInFirstTimeCallsCount = 0
    public var signInFirstTimeCalled: Bool {
        signInFirstTimeCallsCount > 0
    }
    public var signInFirstTimeReceivedArguments: (username: String, password: String, firstTime: Bool)?
    public var signInFirstTimeReceivedInvocations: [(username: String, password: String, firstTime: Bool)] = []
    public var signInFirstTimeReturnValue: AnyPublisher<AccountServiceModel.AccountData, Error>!
    public var signInFirstTimeStub: ((String, String, Bool) -> AnyPublisher<AccountServiceModel.AccountData, Error>)?

    public func signIn(_ username: String, _ password: String, firstTime: Bool) -> AnyPublisher<AccountServiceModel.AccountData, Error> {
        lock.withLock {
            signInFirstTimeCallsCount += 1
        signInFirstTimeReceivedArguments = (username: username, password: password, firstTime: firstTime)
        signInFirstTimeReceivedInvocations.append((username: username, password: password, firstTime: firstTime))
        }
        if let signInFirstTimeStub = signInFirstTimeStub {
            return signInFirstTimeStub(username, password, firstTime)
        } else {
            return signInFirstTimeReturnValue
        }
    }

    //MARK: - confirmSignUp

    public var confirmSignUpWithCallsCount = 0
    public var confirmSignUpWithCalled: Bool {
        confirmSignUpWithCallsCount > 0
    }
    public var confirmSignUpWithReceivedArguments: (confirmationCode: String, username: String, password: String)?
    public var confirmSignUpWithReceivedInvocations: [(confirmationCode: String, username: String, password: String)] = []
    public var confirmSignUpWithReturnValue: AnyPublisher<Void, Error>!
    public var confirmSignUpWithStub: ((String, String, String) -> AnyPublisher<Void, Error>)?

    public func confirmSignUp(with confirmationCode: String, _ username: String, _ password: String) -> AnyPublisher<Void, Error> {
        lock.withLock {
            confirmSignUpWithCallsCount += 1
        confirmSignUpWithReceivedArguments = (confirmationCode: confirmationCode, username: username, password: password)
        confirmSignUpWithReceivedInvocations.append((confirmationCode: confirmationCode, username: username, password: password))
        }
        if let confirmSignUpWithStub = confirmSignUpWithStub {
            return confirmSignUpWithStub(confirmationCode, username, password)
        } else {
            return confirmSignUpWithReturnValue
        }
    }

    //MARK: - resetPassword

    public var resetPasswordUsernameCallsCount = 0
    public var resetPasswordUsernameCalled: Bool {
        resetPasswordUsernameCallsCount > 0
    }
    public var resetPasswordUsernameReceivedUsername: String?
    public var resetPasswordUsernameReceivedInvocations: [String] = []
    public var resetPasswordUsernameReturnValue: AnyPublisher<Void, Error>!
    public var resetPasswordUsernameStub: ((String) -> AnyPublisher<Void, Error>)?

    public func resetPassword(username: String) -> AnyPublisher<Void, Error> {
        lock.withLock {
            resetPasswordUsernameCallsCount += 1
        resetPasswordUsernameReceivedUsername = username
        resetPasswordUsernameReceivedInvocations.append(username)
        }
        if let resetPasswordUsernameStub = resetPasswordUsernameStub {
            return resetPasswordUsernameStub(username)
        } else {
            return resetPasswordUsernameReturnValue
        }
    }

    //MARK: - changePassword

    public var changePasswordOldPasswordNewPasswordCallsCount = 0
    public var changePasswordOldPasswordNewPasswordCalled: Bool {
        changePasswordOldPasswordNewPasswordCallsCount > 0
    }
    public var changePasswordOldPasswordNewPasswordReceivedArguments: (oldPassword: String, newPassword: String)?
    public var changePasswordOldPasswordNewPasswordReceivedInvocations: [(oldPassword: String, newPassword: String)] = []
    public var changePasswordOldPasswordNewPasswordReturnValue: AnyPublisher<Void, Error>!
    public var changePasswordOldPasswordNewPasswordStub: ((String, String) -> AnyPublisher<Void, Error>)?

    public func changePassword(oldPassword: String, newPassword: String) -> AnyPublisher<Void, Error> {
        lock.withLock {
            changePasswordOldPasswordNewPasswordCallsCount += 1
        changePasswordOldPasswordNewPasswordReceivedArguments = (oldPassword: oldPassword, newPassword: newPassword)
        changePasswordOldPasswordNewPasswordReceivedInvocations.append((oldPassword: oldPassword, newPassword: newPassword))
        }
        if let changePasswordOldPasswordNewPasswordStub = changePasswordOldPasswordNewPasswordStub {
            return changePasswordOldPasswordNewPasswordStub(oldPassword, newPassword)
        } else {
            return changePasswordOldPasswordNewPasswordReturnValue
        }
    }

    //MARK: - confirmResetPassword

    public var confirmResetPasswordUsernameNewPasswordConfirmationCodeCallsCount = 0
    public var confirmResetPasswordUsernameNewPasswordConfirmationCodeCalled: Bool {
        confirmResetPasswordUsernameNewPasswordConfirmationCodeCallsCount > 0
    }
    public var confirmResetPasswordUsernameNewPasswordConfirmationCodeReceivedArguments: (username: String, newPassword: String, confirmationCode: String)?
    public var confirmResetPasswordUsernameNewPasswordConfirmationCodeReceivedInvocations: [(username: String, newPassword: String, confirmationCode: String)] = []
    public var confirmResetPasswordUsernameNewPasswordConfirmationCodeReturnValue: AnyPublisher<Void, Error>!
    public var confirmResetPasswordUsernameNewPasswordConfirmationCodeStub: ((String, String, String) -> AnyPublisher<Void, Error>)?

    public func confirmResetPassword(username: String, newPassword: String, confirmationCode: String) -> AnyPublisher<Void, Error> {
        lock.withLock {
            confirmResetPasswordUsernameNewPasswordConfirmationCodeCallsCount += 1
        confirmResetPasswordUsernameNewPasswordConfirmationCodeReceivedArguments = (username: username, newPassword: newPassword, confirmationCode: confirmationCode)
        confirmResetPasswordUsernameNewPasswordConfirmationCodeReceivedInvocations.append((username: username, newPassword: newPassword, confirmationCode: confirmationCode))
        }
        if let confirmResetPasswordUsernameNewPasswordConfirmationCodeStub = confirmResetPasswordUsernameNewPasswordConfirmationCodeStub {
            return confirmResetPasswordUsernameNewPasswordConfirmationCodeStub(username, newPassword, confirmationCode)
        } else {
            return confirmResetPasswordUsernameNewPasswordConfirmationCodeReturnValue
        }
    }

    //MARK: - updateLeaderboard

    public var updateLeaderboardTimeDistanceCallsCount = 0
    public var updateLeaderboardTimeDistanceCalled: Bool {
        updateLeaderboardTimeDistanceCallsCount > 0
    }
    public var updateLeaderboardTimeDistanceReceivedArguments: (time: Double, distance: Double)?
    public var updateLeaderboardTimeDistanceReceivedInvocations: [(time: Double, distance: Double)] = []
    public var updateLeaderboardTimeDistanceStub: ((Double, Double) -> Void)?

    public func updateLeaderboard(time: Double, distance: Double) {
        lock.withLock {
            updateLeaderboardTimeDistanceCallsCount += 1
        updateLeaderboardTimeDistanceReceivedArguments = (time: time, distance: distance)
        updateLeaderboardTimeDistanceReceivedInvocations.append((time: time, distance: distance))
        }
        updateLeaderboardTimeDistanceStub?(time, distance)
    }

    //MARK: - updateLocation

    public var updateLocationXCoordYCoordCallsCount = 0
    public var updateLocationXCoordYCoordCalled: Bool {
        updateLocationXCoordYCoordCallsCount > 0
    }
    public var updateLocationXCoordYCoordReceivedArguments: (xCoord: String, yCoord: String)?
    public var updateLocationXCoordYCoordReceivedInvocations: [(xCoord: String, yCoord: String)] = []
    public var updateLocationXCoordYCoordStub: ((String, String) -> Void)?

    public func updateLocation(xCoord: String, yCoord: String) {
        lock.withLock {
            updateLocationXCoordYCoordCallsCount += 1
        updateLocationXCoordYCoordReceivedArguments = (xCoord: xCoord, yCoord: yCoord)
        updateLocationXCoordYCoordReceivedInvocations.append((xCoord: xCoord, yCoord: yCoord))
        }
        updateLocationXCoordYCoordStub?(xCoord, yCoord)
    }

    //MARK: - signOut

    public var signOutCallsCount = 0
    public var signOutCalled: Bool {
        signOutCallsCount > 0
    }
    public var signOutStub: (() async -> Void)?

    public func signOut() async {
        lock.withLock {
            signOutCallsCount += 1
        }
        await signOutStub?()
    }

}
public final class ChangePasswordViewNavigatorProtocolMock: ChangePasswordViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - changeButtonTapped

    public var changeButtonTappedCallsCount = 0
    public var changeButtonTappedCalled: Bool {
        changeButtonTappedCallsCount > 0
    }
    public var changeButtonTappedStub: (() -> Void)?

    public func changeButtonTapped() {
        lock.withLock {
            changeButtonTappedCallsCount += 1
        }
        changeButtonTappedStub?()
    }

    //MARK: - navigateBack

    public var navigateBackCallsCount = 0
    public var navigateBackCalled: Bool {
        navigateBackCallsCount > 0
    }
    public var navigateBackStub: (() -> Void)?

    public func navigateBack() {
        lock.withLock {
            navigateBackCallsCount += 1
        }
        navigateBackStub?()
    }

}
public final class ChatServiceProtocolMock: ChatServiceProtocol {
private let lock = NSLock()
    public var messagesPublisher: AnyPublisher<[ExyteChat.Message]?, Never> {
        get { return underlyingMessagesPublisher }
        set(value) { underlyingMessagesPublisher = value }
    }
    public var underlyingMessagesPublisher: AnyPublisher<[ExyteChat.Message]?, Never>!
    public var chatNotificationPublisher: AnyPublisher<[String]?, Never> {
        get { return underlyingChatNotificationPublisher }
        set(value) { underlyingChatNotificationPublisher = value }
    }
    public var underlyingChatNotificationPublisher: AnyPublisher<[String]?, Never>!
    public var networkErrorPublisher: AnyPublisher<ToastModel?, Never> {
        get { return underlyingNetworkErrorPublisher }
        set(value) { underlyingNetworkErrorPublisher = value }
    }
    public var underlyingNetworkErrorPublisher: AnyPublisher<ToastModel?, Never>!
    public var lastMessagesPublisher: AnyPublisher<[SocialView.LastMessageModel]?, Never> {
        get { return underlyingLastMessagesPublisher }
        set(value) { underlyingLastMessagesPublisher = value }
    }
    public var underlyingLastMessagesPublisher: AnyPublisher<[SocialView.LastMessageModel]?, Never>!

public init() {}

    //MARK: - sendMessage

    public var sendMessageMessageRecipientCallsCount = 0
    public var sendMessageMessageRecipientCalled: Bool {
        sendMessageMessageRecipientCallsCount > 0
    }
    public var sendMessageMessageRecipientReceivedArguments: (message: ExyteChat.Message, recipient: String)?
    public var sendMessageMessageRecipientReceivedInvocations: [(message: ExyteChat.Message, recipient: String)] = []
    public var sendMessageMessageRecipientStub: ((ExyteChat.Message, String) -> Void)?

    public func sendMessage(message: ExyteChat.Message, recipient: String) {
        lock.withLock {
            sendMessageMessageRecipientCallsCount += 1
        sendMessageMessageRecipientReceivedArguments = (message: message, recipient: recipient)
        sendMessageMessageRecipientReceivedInvocations.append((message: message, recipient: recipient))
        }
        sendMessageMessageRecipientStub?(message, recipient)
    }

    //MARK: - queryChat

    public var queryChatRecipientCallsCount = 0
    public var queryChatRecipientCalled: Bool {
        queryChatRecipientCallsCount > 0
    }
    public var queryChatRecipientReceivedRecipient: String?
    public var queryChatRecipientReceivedInvocations: [String] = []
    public var queryChatRecipientStub: ((String) -> Void)?

    public func queryChat(recipient: String) {
        lock.withLock {
            queryChatRecipientCallsCount += 1
        queryChatRecipientReceivedRecipient = recipient
        queryChatRecipientReceivedInvocations.append(recipient)
        }
        queryChatRecipientStub?(recipient)
    }

    //MARK: - updateMessageStatus

    public var updateMessageStatusRecipientCallsCount = 0
    public var updateMessageStatusRecipientCalled: Bool {
        updateMessageStatusRecipientCallsCount > 0
    }
    public var updateMessageStatusRecipientReceivedRecipient: String?
    public var updateMessageStatusRecipientReceivedInvocations: [String] = []
    public var updateMessageStatusRecipientStub: ((String) -> Void)?

    public func updateMessageStatus(recipient: String) {
        lock.withLock {
            updateMessageStatusRecipientCallsCount += 1
        updateMessageStatusRecipientReceivedRecipient = recipient
        updateMessageStatusRecipientReceivedInvocations.append(recipient)
        }
        updateMessageStatusRecipientStub?(recipient)
    }

    //MARK: - getChatNotifications

    public var getChatNotificationsCallsCount = 0
    public var getChatNotificationsCalled: Bool {
        getChatNotificationsCallsCount > 0
    }
    public var getChatNotificationsStub: (() -> Void)?

    public func getChatNotifications() {
        lock.withLock {
            getChatNotificationsCallsCount += 1
        }
        getChatNotificationsStub?()
    }

}
public final class FriendServiceProtocolMock: FriendServiceProtocol {
private let lock = NSLock()
    public var friendListPublisher: AnyPublisher<Friendlist?, Never> {
        get { return underlyingFriendListPublisher }
        set(value) { underlyingFriendListPublisher = value }
    }
    public var underlyingFriendListPublisher: AnyPublisher<Friendlist?, Never>!
    public var friendRequestsPublisher: AnyPublisher<[FriendRequest], Never> {
        get { return underlyingFriendRequestsPublisher }
        set(value) { underlyingFriendRequestsPublisher = value }
    }
    public var underlyingFriendRequestsPublisher: AnyPublisher<[FriendRequest], Never>!
    public var friendPositionPublisher: AnyPublisher<Location?, Never> {
        get { return underlyingFriendPositionPublisher }
        set(value) { underlyingFriendPositionPublisher = value }
    }
    public var underlyingFriendPositionPublisher: AnyPublisher<Location?, Never>!
    public var friendPositionsPublisher: AnyPublisher<[Location], Never> {
        get { return underlyingFriendPositionsPublisher }
        set(value) { underlyingFriendPositionsPublisher = value }
    }
    public var underlyingFriendPositionsPublisher: AnyPublisher<[Location], Never>!
    public var networkErrorPublisher: AnyPublisher<ToastModel?, Never> {
        get { return underlyingNetworkErrorPublisher }
        set(value) { underlyingNetworkErrorPublisher = value }
    }
    public var underlyingNetworkErrorPublisher: AnyPublisher<ToastModel?, Never>!

public init() {}

    //MARK: - updateTracking

    public var updateTrackingIdCallsCount = 0
    public var updateTrackingIdCalled: Bool {
        updateTrackingIdCallsCount > 0
    }
    public var updateTrackingIdReceivedId: String?
    public var updateTrackingIdReceivedInvocations: [String] = []
    public var updateTrackingIdStub: ((String) -> Void)?

    public func updateTracking(id: String) {
        lock.withLock {
            updateTrackingIdCallsCount += 1
        updateTrackingIdReceivedId = id
        updateTrackingIdReceivedInvocations.append(id)
        }
        updateTrackingIdStub?(id)
    }

    //MARK: - queryFriends

    public var queryFriendsCallsCount = 0
    public var queryFriendsCalled: Bool {
        queryFriendsCallsCount > 0
    }
    public var queryFriendsStub: (() -> Void)?

    public func queryFriends() {
        lock.withLock {
            queryFriendsCallsCount += 1
        }
        queryFriendsStub?()
    }

    //MARK: - addFriend

    public var addFriendRequestCallsCount = 0
    public var addFriendRequestCalled: Bool {
        addFriendRequestCallsCount > 0
    }
    public var addFriendRequestReceivedRequest: FriendRequest?
    public var addFriendRequestReceivedInvocations: [FriendRequest] = []
    public var addFriendRequestStub: ((FriendRequest) -> Void)?

    public func addFriend(request: FriendRequest) {
        lock.withLock {
            addFriendRequestCallsCount += 1
        addFriendRequestReceivedRequest = request
        addFriendRequestReceivedInvocations.append(request)
        }
        addFriendRequestStub?(request)
    }

    //MARK: - deleteFriend

    public var deleteFriendFriendCallsCount = 0
    public var deleteFriendFriendCalled: Bool {
        deleteFriendFriendCallsCount > 0
    }
    public var deleteFriendFriendReceivedFriend: Friend?
    public var deleteFriendFriendReceivedInvocations: [Friend] = []
    public var deleteFriendFriendStub: ((Friend) -> Void)?

    public func deleteFriend(friend: Friend) {
        lock.withLock {
            deleteFriendFriendCallsCount += 1
        deleteFriendFriendReceivedFriend = friend
        deleteFriendFriendReceivedInvocations.append(friend)
        }
        deleteFriendFriendStub?(friend)
    }

    //MARK: - sendFriendRequest

    public var sendFriendRequestRecipientCallsCount = 0
    public var sendFriendRequestRecipientCalled: Bool {
        sendFriendRequestRecipientCallsCount > 0
    }
    public var sendFriendRequestRecipientReceivedRecipient: String?
    public var sendFriendRequestRecipientReceivedInvocations: [String] = []
    public var sendFriendRequestRecipientReturnValue: Future<Void, Error>!
    public var sendFriendRequestRecipientStub: ((String) -> Future<Void, Error>)?

    public func sendFriendRequest(recipient: String) -> Future<Void, Error> {
        lock.withLock {
            sendFriendRequestRecipientCallsCount += 1
        sendFriendRequestRecipientReceivedRecipient = recipient
        sendFriendRequestRecipientReceivedInvocations.append(recipient)
        }
        if let sendFriendRequestRecipientStub = sendFriendRequestRecipientStub {
            return sendFriendRequestRecipientStub(recipient)
        } else {
            return sendFriendRequestRecipientReturnValue
        }
    }

    //MARK: - queryFriendRequests

    public var queryFriendRequestsCallsCount = 0
    public var queryFriendRequestsCalled: Bool {
        queryFriendRequestsCallsCount > 0
    }
    public var queryFriendRequestsStub: (() -> Void)?

    public func queryFriendRequests() {
        lock.withLock {
            queryFriendRequestsCallsCount += 1
        }
        queryFriendRequestsStub?()
    }

    //MARK: - queryFriendLocations

    public var queryFriendLocationsCallsCount = 0
    public var queryFriendLocationsCalled: Bool {
        queryFriendLocationsCallsCount > 0
    }
    public var queryFriendLocationsStub: (() -> Void)?

    public func queryFriendLocations() {
        lock.withLock {
            queryFriendLocationsCallsCount += 1
        }
        queryFriendLocationsStub?()
    }

    //MARK: - getUsers

    public var getUsersCallsCount = 0
    public var getUsersCalled: Bool {
        getUsersCallsCount > 0
    }
    public var getUsersReturnValue: Future<[User], Error>!
    public var getUsersStub: (() -> Future<[User], Error>)?

    public func getUsers() -> Future<[User], Error> {
        lock.withLock {
            getUsersCallsCount += 1
        }
        if let getUsersStub = getUsersStub {
            return getUsersStub()
        } else {
            return getUsersReturnValue
        }
    }

    //MARK: - getAddableUsers

    public var getAddableUsersCallsCount = 0
    public var getAddableUsersCalled: Bool {
        getAddableUsersCallsCount > 0
    }
    public var getAddableUsersReturnValue: Future<[User], Error>!
    public var getAddableUsersStub: (() -> Future<[User], Error>)?

    public func getAddableUsers() -> Future<[User], Error> {
        lock.withLock {
            getAddableUsersCallsCount += 1
        }
        if let getAddableUsersStub = getAddableUsersStub {
            return getAddableUsersStub()
        } else {
            return getAddableUsersReturnValue
        }
    }

}
public final class LoginViewNavigatorProtocolMock: LoginViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - loggedIn

    public var loggedInCallsCount = 0
    public var loggedInCalled: Bool {
        loggedInCallsCount > 0
    }
    public var loggedInStub: (() -> Void)?

    public func loggedIn() {
        lock.withLock {
            loggedInCallsCount += 1
        }
        loggedInStub?()
    }

    //MARK: - navigateToResetPassword

    public var navigateToResetPasswordCallsCount = 0
    public var navigateToResetPasswordCalled: Bool {
        navigateToResetPasswordCallsCount > 0
    }
    public var navigateToResetPasswordStub: (() -> Void)?

    public func navigateToResetPassword() {
        lock.withLock {
            navigateToResetPasswordCallsCount += 1
        }
        navigateToResetPasswordStub?()
    }

    //MARK: - dismiss

    public var dismissCallsCount = 0
    public var dismissCalled: Bool {
        dismissCallsCount > 0
    }
    public var dismissStub: (() -> Void)?

    public func dismiss() {
        lock.withLock {
            dismissCallsCount += 1
        }
        dismissStub?()
    }

}
public final class MapServiceProtocolMock: MapServiceProtocol {
private let lock = NSLock()
    public var trackingPublisher: AnyPublisher<TrackedPath?, Never> {
        get { return underlyingTrackingPublisher }
        set(value) { underlyingTrackingPublisher = value }
    }
    public var underlyingTrackingPublisher: AnyPublisher<TrackedPath?, Never>!
    public var trackedPathPublisher: AnyPublisher<TrackedPathModel?, Never> {
        get { return underlyingTrackedPathPublisher }
        set(value) { underlyingTrackedPathPublisher = value }
    }
    public var underlyingTrackedPathPublisher: AnyPublisher<TrackedPathModel?, Never>!
    public var sharedPathPublisher: AnyPublisher<TrackedPathModel?, Never> {
        get { return underlyingSharedPathPublisher }
        set(value) { underlyingSharedPathPublisher = value }
    }
    public var underlyingSharedPathPublisher: AnyPublisher<TrackedPathModel?, Never>!
    public var raceCreationStatePublisher: AnyPublisher<RaceCreationState, Never> {
        get { return underlyingRaceCreationStatePublisher }
        set(value) { underlyingRaceCreationStatePublisher = value }
    }
    public var underlyingRaceCreationStatePublisher: AnyPublisher<RaceCreationState, Never>!
    public var racesPublisher: AnyPublisher<[Race], Never> {
        get { return underlyingRacesPublisher }
        set(value) { underlyingRacesPublisher = value }
    }
    public var underlyingRacesPublisher: AnyPublisher<[Race], Never>!
    public var networkErrorPublisher: AnyPublisher<ToastModel?, Never> {
        get { return underlyingNetworkErrorPublisher }
        set(value) { underlyingNetworkErrorPublisher = value }
    }
    public var underlyingNetworkErrorPublisher: AnyPublisher<ToastModel?, Never>!

public init() {}

    //MARK: - updateTrackedPath

    public var updateTrackedPathCallsCount = 0
    public var updateTrackedPathCalled: Bool {
        updateTrackedPathCallsCount > 0
    }
    public var updateTrackedPathReceivedTrackedPath: TrackedPath?
    public var updateTrackedPathReceivedInvocations: [TrackedPath] = []
    public var updateTrackedPathStub: ((TrackedPath) -> Void)?

    public func updateTrackedPath(_ trackedPath: TrackedPath) {
        lock.withLock {
            updateTrackedPathCallsCount += 1
        updateTrackedPathReceivedTrackedPath = trackedPath
        updateTrackedPathReceivedInvocations.append(trackedPath)
        }
        updateTrackedPathStub?(trackedPath)
    }

    //MARK: - updateTrack

    public var updateTrackCallsCount = 0
    public var updateTrackCalled: Bool {
        updateTrackCallsCount > 0
    }
    public var updateTrackReceivedArguments: (trackedPath: TrackedPath, shared: Bool)?
    public var updateTrackReceivedInvocations: [(trackedPath: TrackedPath, shared: Bool)] = []
    public var updateTrackStub: ((TrackedPath, Bool) -> Void)?

    public func updateTrack(_ trackedPath: TrackedPath, _ shared: Bool) {
        lock.withLock {
            updateTrackCallsCount += 1
        updateTrackReceivedArguments = (trackedPath: trackedPath, shared: shared)
        updateTrackReceivedInvocations.append((trackedPath: trackedPath, shared: shared))
        }
        updateTrackStub?(trackedPath, shared)
    }

    //MARK: - shareTrack

    public var shareTrackCallsCount = 0
    public var shareTrackCalled: Bool {
        shareTrackCallsCount > 0
    }
    public var shareTrackReceivedArguments: (trackedPath: TrackedPath, friend: String)?
    public var shareTrackReceivedInvocations: [(trackedPath: TrackedPath, friend: String)] = []
    public var shareTrackStub: ((TrackedPath, String) -> Void)?

    public func shareTrack(_ trackedPath: TrackedPath, _ friend: String) {
        lock.withLock {
            shareTrackCallsCount += 1
        shareTrackReceivedArguments = (trackedPath: trackedPath, friend: friend)
        shareTrackReceivedInvocations.append((trackedPath: trackedPath, friend: friend))
        }
        shareTrackStub?(trackedPath, friend)
    }

    //MARK: - removeTrackedPath

    public var removeTrackedPathCallsCount = 0
    public var removeTrackedPathCalled: Bool {
        removeTrackedPathCallsCount > 0
    }
    public var removeTrackedPathReceivedTrackedPath: TrackedPath?
    public var removeTrackedPathReceivedInvocations: [TrackedPath] = []
    public var removeTrackedPathStub: ((TrackedPath) -> Void)?

    public func removeTrackedPath(_ trackedPath: TrackedPath) {
        lock.withLock {
            removeTrackedPathCallsCount += 1
        removeTrackedPathReceivedTrackedPath = trackedPath
        removeTrackedPathReceivedInvocations.append(trackedPath)
        }
        removeTrackedPathStub?(trackedPath)
    }

    //MARK: - removeSharedTrackedPath

    public var removeSharedTrackedPathCallsCount = 0
    public var removeSharedTrackedPathCalled: Bool {
        removeSharedTrackedPathCallsCount > 0
    }
    public var removeSharedTrackedPathReceivedTrackedPath: TrackedPath?
    public var removeSharedTrackedPathReceivedInvocations: [TrackedPath] = []
    public var removeSharedTrackedPathStub: ((TrackedPath) -> Void)?

    public func removeSharedTrackedPath(_ trackedPath: TrackedPath) {
        lock.withLock {
            removeSharedTrackedPathCallsCount += 1
        removeSharedTrackedPathReceivedTrackedPath = trackedPath
        removeSharedTrackedPathReceivedInvocations.append(trackedPath)
        }
        removeSharedTrackedPathStub?(trackedPath)
    }

    //MARK: - queryTrackedPaths

    public var queryTrackedPathsCallsCount = 0
    public var queryTrackedPathsCalled: Bool {
        queryTrackedPathsCallsCount > 0
    }
    public var queryTrackedPathsStub: (() -> Void)?

    public func queryTrackedPaths() {
        lock.withLock {
            queryTrackedPathsCallsCount += 1
        }
        queryTrackedPathsStub?()
    }

    //MARK: - queryTrackedPathsWithId

    public var queryTrackedPathsWithIdCallsCount = 0
    public var queryTrackedPathsWithIdCalled: Bool {
        queryTrackedPathsWithIdCallsCount > 0
    }
    public var queryTrackedPathsWithIdReceivedId: String?
    public var queryTrackedPathsWithIdReceivedInvocations: [String?] = []
    public var queryTrackedPathsWithIdStub: ((String?) -> Void)?

    public func queryTrackedPathsWithId(_ id: String?) {
        lock.withLock {
            queryTrackedPathsWithIdCallsCount += 1
        queryTrackedPathsWithIdReceivedId = id
        queryTrackedPathsWithIdReceivedInvocations.append(id)
        }
        queryTrackedPathsWithIdStub?(id)
    }

    //MARK: - querySharedPaths

    public var querySharedPathsCallsCount = 0
    public var querySharedPathsCalled: Bool {
        querySharedPathsCallsCount > 0
    }
    public var querySharedPathsStub: (() -> Void)?

    public func querySharedPaths() {
        lock.withLock {
            querySharedPathsCallsCount += 1
        }
        querySharedPathsStub?()
    }

    //MARK: - sendCurrentlyTracked

    public var sendCurrentlyTrackedCallsCount = 0
    public var sendCurrentlyTrackedCalled: Bool {
        sendCurrentlyTrackedCallsCount > 0
    }
    public var sendCurrentlyTrackedReceivedTrackedPath: TrackedPath?
    public var sendCurrentlyTrackedReceivedInvocations: [TrackedPath] = []
    public var sendCurrentlyTrackedStub: ((TrackedPath) -> Void)?

    public func sendCurrentlyTracked(_ trackedPath: TrackedPath) {
        lock.withLock {
            sendCurrentlyTrackedCallsCount += 1
        sendCurrentlyTrackedReceivedTrackedPath = trackedPath
        sendCurrentlyTrackedReceivedInvocations.append(trackedPath)
        }
        sendCurrentlyTrackedStub?(trackedPath)
    }

    //MARK: - changeRaceCreationState

    public var changeRaceCreationStateCallsCount = 0
    public var changeRaceCreationStateCalled: Bool {
        changeRaceCreationStateCallsCount > 0
    }
    public var changeRaceCreationStateReceivedRaceCreationState: RaceCreationState?
    public var changeRaceCreationStateReceivedInvocations: [RaceCreationState] = []
    public var changeRaceCreationStateStub: ((RaceCreationState) -> Void)?

    public func changeRaceCreationState(_ raceCreationState: RaceCreationState) {
        lock.withLock {
            changeRaceCreationStateCallsCount += 1
        changeRaceCreationStateReceivedRaceCreationState = raceCreationState
        changeRaceCreationStateReceivedInvocations.append(raceCreationState)
        }
        changeRaceCreationStateStub?(raceCreationState)
    }

    //MARK: - createRace

    public var createRaceCallsCount = 0
    public var createRaceCalled: Bool {
        createRaceCallsCount > 0
    }
    public var createRaceReceivedArguments: (xCoords: [Double], yCoords: [Double], name: String)?
    public var createRaceReceivedInvocations: [(xCoords: [Double], yCoords: [Double], name: String)] = []
    public var createRaceStub: (([Double], [Double], String) -> Void)?

    public func createRace(_ xCoords: [Double], _ yCoords: [Double], _ name: String) {
        lock.withLock {
            createRaceCallsCount += 1
        createRaceReceivedArguments = (xCoords: xCoords, yCoords: yCoords, name: name)
        createRaceReceivedInvocations.append((xCoords: xCoords, yCoords: yCoords, name: name))
        }
        createRaceStub?(xCoords, yCoords, name)
    }

    //MARK: - queryRaces

    public var queryRacesCallsCount = 0
    public var queryRacesCalled: Bool {
        queryRacesCallsCount > 0
    }
    public var queryRacesStub: (() -> Void)?

    public func queryRaces() {
        lock.withLock {
            queryRacesCallsCount += 1
        }
        queryRacesStub?()
    }

    //MARK: - sendRaceRun

    public var sendRaceRunCallsCount = 0
    public var sendRaceRunCalled: Bool {
        sendRaceRunCallsCount > 0
    }
    public var sendRaceRunReceivedArguments: (run: TrackedPath, raceId: String)?
    public var sendRaceRunReceivedInvocations: [(run: TrackedPath, raceId: String)] = []
    public var sendRaceRunStub: ((TrackedPath, String) -> Void)?

    public func sendRaceRun(_ run: TrackedPath, _ raceId: String) {
        lock.withLock {
            sendRaceRunCallsCount += 1
        sendRaceRunReceivedArguments = (run: run, raceId: raceId)
        sendRaceRunReceivedInvocations.append((run: run, raceId: raceId))
        }
        sendRaceRunStub?(run, raceId)
    }

    //MARK: - updateRace

    public var updateRaceCallsCount = 0
    public var updateRaceCalled: Bool {
        updateRaceCallsCount > 0
    }
    public var updateRaceReceivedArguments: (race: Race, newRace: Race)?
    public var updateRaceReceivedInvocations: [(race: Race, newRace: Race)] = []
    public var updateRaceStub: ((Race, Race) -> Void)?

    public func updateRace(_ race: Race, _ newRace: Race) {
        lock.withLock {
            updateRaceCallsCount += 1
        updateRaceReceivedArguments = (race: race, newRace: newRace)
        updateRaceReceivedInvocations.append((race: race, newRace: newRace))
        }
        updateRaceStub?(race, newRace)
    }

    //MARK: - shareRace

    public var shareRaceCallsCount = 0
    public var shareRaceCalled: Bool {
        shareRaceCallsCount > 0
    }
    public var shareRaceReceivedArguments: (friend: String, race: Race)?
    public var shareRaceReceivedInvocations: [(friend: String, race: Race)] = []
    public var shareRaceStub: ((String, Race) -> Void)?

    public func shareRace(_ friend: String, _ race: Race) {
        lock.withLock {
            shareRaceCallsCount += 1
        shareRaceReceivedArguments = (friend: friend, race: race)
        shareRaceReceivedInvocations.append((friend: friend, race: race))
        }
        shareRaceStub?(friend, race)
    }

    //MARK: - deleteRace

    public var deleteRaceCallsCount = 0
    public var deleteRaceCalled: Bool {
        deleteRaceCallsCount > 0
    }
    public var deleteRaceReceivedRace: Race?
    public var deleteRaceReceivedInvocations: [Race] = []
    public var deleteRaceStub: ((Race) -> Void)?

    public func deleteRace(_ race: Race) {
        lock.withLock {
            deleteRaceCallsCount += 1
        deleteRaceReceivedRace = race
        deleteRaceReceivedInvocations.append(race)
        }
        deleteRaceStub?(race)
    }

}
public final class ProfileViewNavigatorProtocolMock: ProfileViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - dismissScreen

    public var dismissScreenCallsCount = 0
    public var dismissScreenCalled: Bool {
        dismissScreenCallsCount > 0
    }
    public var dismissScreenStub: (() -> Void)?

    public func dismissScreen() {
        lock.withLock {
            dismissScreenCallsCount += 1
        }
        dismissScreenStub?()
    }

    //MARK: - login

    public var loginCallsCount = 0
    public var loginCalled: Bool {
        loginCallsCount > 0
    }
    public var loginStub: (() -> Void)?

    public func login() {
        lock.withLock {
            loginCallsCount += 1
        }
        loginStub?()
    }

    //MARK: - register

    public var registerCallsCount = 0
    public var registerCalled: Bool {
        registerCallsCount > 0
    }
    public var registerStub: (() -> Void)?

    public func register() {
        lock.withLock {
            registerCallsCount += 1
        }
        registerStub?()
    }

    //MARK: - updatePassword

    public var updatePasswordCallsCount = 0
    public var updatePasswordCalled: Bool {
        updatePasswordCallsCount > 0
    }
    public var updatePasswordStub: (() -> Void)?

    public func updatePassword() {
        lock.withLock {
            updatePasswordCallsCount += 1
        }
        updatePasswordStub?()
    }

}
public final class RaceRunViewNavigatorProtocolMock: RaceRunViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - navigateBack

    public var navigateBackCallsCount = 0
    public var navigateBackCalled: Bool {
        navigateBackCallsCount > 0
    }
    public var navigateBackStub: (() -> Void)?

    public func navigateBack() {
        lock.withLock {
            navigateBackCallsCount += 1
        }
        navigateBackStub?()
    }

}
public final class RacesViewNavigatorProtocolMock: RacesViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - navigateToRaceRuns

    public var navigateToRaceRunsRaceCallsCount = 0
    public var navigateToRaceRunsRaceCalled: Bool {
        navigateToRaceRunsRaceCallsCount > 0
    }
    public var navigateToRaceRunsRaceReceivedRace: Race?
    public var navigateToRaceRunsRaceReceivedInvocations: [Race] = []
    public var navigateToRaceRunsRaceStub: ((Race) -> Void)?

    public func navigateToRaceRuns(race: Race) {
        lock.withLock {
            navigateToRaceRunsRaceCallsCount += 1
        navigateToRaceRunsRaceReceivedRace = race
        navigateToRaceRunsRaceReceivedInvocations.append(race)
        }
        navigateToRaceRunsRaceStub?(race)
    }

}
public final class RegisterVerificationViewNavigatorProtocolMock: RegisterVerificationViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - verified

    public var verifiedCallsCount = 0
    public var verifiedCalled: Bool {
        verifiedCallsCount > 0
    }
    public var verifiedStub: (() -> Void)?

    public func verified() {
        lock.withLock {
            verifiedCallsCount += 1
        }
        verifiedStub?()
    }

}
public final class RegisterViewNavigatorProtocolMock: RegisterViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - registered

    public var registeredUsernamePasswordCallsCount = 0
    public var registeredUsernamePasswordCalled: Bool {
        registeredUsernamePasswordCallsCount > 0
    }
    public var registeredUsernamePasswordReceivedArguments: (username: String, password: String)?
    public var registeredUsernamePasswordReceivedInvocations: [(username: String, password: String)] = []
    public var registeredUsernamePasswordStub: ((String, String) -> Void)?

    public func registered(username: String, password: String) {
        lock.withLock {
            registeredUsernamePasswordCallsCount += 1
        registeredUsernamePasswordReceivedArguments = (username: username, password: password)
        registeredUsernamePasswordReceivedInvocations.append((username: username, password: password))
        }
        registeredUsernamePasswordStub?(username, password)
    }

    //MARK: - dismiss

    public var dismissCallsCount = 0
    public var dismissCalled: Bool {
        dismissCallsCount > 0
    }
    public var dismissStub: (() -> Void)?

    public func dismiss() {
        lock.withLock {
            dismissCallsCount += 1
        }
        dismissStub?()
    }

}
public final class ResetPasswordVerificationNavigatorProtocolMock: ResetPasswordVerificationNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - verifyButtonTapped

    public var verifyButtonTappedCallsCount = 0
    public var verifyButtonTappedCalled: Bool {
        verifyButtonTappedCallsCount > 0
    }
    public var verifyButtonTappedStub: (() -> Void)?

    public func verifyButtonTapped() {
        lock.withLock {
            verifyButtonTappedCallsCount += 1
        }
        verifyButtonTappedStub?()
    }

    //MARK: - navigateBack

    public var navigateBackCallsCount = 0
    public var navigateBackCalled: Bool {
        navigateBackCallsCount > 0
    }
    public var navigateBackStub: (() -> Void)?

    public func navigateBack() {
        lock.withLock {
            navigateBackCallsCount += 1
        }
        navigateBackStub?()
    }

}
public final class ResetPasswordViewNavigatorProtocolMock: ResetPasswordViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - resetButtonTapped

    public var resetButtonTappedUsernameCallsCount = 0
    public var resetButtonTappedUsernameCalled: Bool {
        resetButtonTappedUsernameCallsCount > 0
    }
    public var resetButtonTappedUsernameReceivedUsername: String?
    public var resetButtonTappedUsernameReceivedInvocations: [String] = []
    public var resetButtonTappedUsernameStub: ((String) -> Void)?

    public func resetButtonTapped(username: String) {
        lock.withLock {
            resetButtonTappedUsernameCallsCount += 1
        resetButtonTappedUsernameReceivedUsername = username
        resetButtonTappedUsernameReceivedInvocations.append(username)
        }
        resetButtonTappedUsernameStub?(username)
    }

    //MARK: - navigateBack

    public var navigateBackCallsCount = 0
    public var navigateBackCalled: Bool {
        navigateBackCallsCount > 0
    }
    public var navigateBackStub: (() -> Void)?

    public func navigateBack() {
        lock.withLock {
            navigateBackCallsCount += 1
        }
        navigateBackStub?()
    }

}
public final class SocialAddViewNavigatorProtocolMock: SocialAddViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - navigateBack

    public var navigateBackCallsCount = 0
    public var navigateBackCalled: Bool {
        navigateBackCallsCount > 0
    }
    public var navigateBackStub: (() -> Void)?

    public func navigateBack() {
        lock.withLock {
            navigateBackCallsCount += 1
        }
        navigateBackStub?()
    }

}
public final class SocialListViewNavigatorProtocolMock: SocialListViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

    //MARK: - navigateToRequest

    public var navigateToRequestCallsCount = 0
    public var navigateToRequestCalled: Bool {
        navigateToRequestCallsCount > 0
    }
    public var navigateToRequestStub: (() -> Void)?

    public func navigateToRequest() {
        lock.withLock {
            navigateToRequestCallsCount += 1
        }
        navigateToRequestStub?()
    }

    //MARK: - navigateToAdd

    public var navigateToAddUsersCallsCount = 0
    public var navigateToAddUsersCalled: Bool {
        navigateToAddUsersCallsCount > 0
    }
    public var navigateToAddUsersReceivedUsers: [User]?
    public var navigateToAddUsersReceivedInvocations: [[User]] = []
    public var navigateToAddUsersStub: (([User]) -> Void)?

    public func navigateToAdd(users: [User]) {
        lock.withLock {
            navigateToAddUsersCallsCount += 1
        navigateToAddUsersReceivedUsers = users
        navigateToAddUsersReceivedInvocations.append(users)
        }
        navigateToAddUsersStub?(users)
    }

    //MARK: - navigateToChat

    public var navigateToChatModelCallsCount = 0
    public var navigateToChatModelCalled: Bool {
        navigateToChatModelCallsCount > 0
    }
    public var navigateToChatModelReceivedModel: PowderTrackrChatView.InputModel?
    public var navigateToChatModelReceivedInvocations: [PowderTrackrChatView.InputModel] = []
    public var navigateToChatModelStub: ((PowderTrackrChatView.InputModel) -> Void)?

    public func navigateToChat(model: PowderTrackrChatView.InputModel) {
        lock.withLock {
            navigateToChatModelCallsCount += 1
        navigateToChatModelReceivedModel = model
        navigateToChatModelReceivedInvocations.append(model)
        }
        navigateToChatModelStub?(model)
    }

}
public final class SocialRequestsViewNavigatorProtocolMock: SocialRequestsViewNavigatorProtocol {
private let lock = NSLock()

public init() {}

}
public final class StatisticsServiceProtocolMock: StatisticsServiceProtocol {
private let lock = NSLock()
    public var leaderboardPublisher: AnyPublisher<[LeaderBoard], Never> {
        get { return underlyingLeaderboardPublisher }
        set(value) { underlyingLeaderboardPublisher = value }
    }
    public var underlyingLeaderboardPublisher: AnyPublisher<[LeaderBoard], Never>!
    public var networkErrorPublisher: AnyPublisher<ToastModel?, Never> {
        get { return underlyingNetworkErrorPublisher }
        set(value) { underlyingNetworkErrorPublisher = value }
    }
    public var underlyingNetworkErrorPublisher: AnyPublisher<ToastModel?, Never>!

public init() {}

    //MARK: - loadLeaderboard

    public var loadLeaderboardCallsCount = 0
    public var loadLeaderboardCalled: Bool {
        loadLeaderboardCallsCount > 0
    }
    public var loadLeaderboardStub: (() -> Void)?

    public func loadLeaderboard() {
        lock.withLock {
            loadLeaderboardCallsCount += 1
        }
        loadLeaderboardStub?()
    }

}
