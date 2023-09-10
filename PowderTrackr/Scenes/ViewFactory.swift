import Factory
import GoogleMaps
import SwiftUI

enum ViewFactory {
    static func powderTrackrView() -> PowderTrackrView {
        Container.PowderTrackr.view()
    }

    // MARK: - PROFILE
    static func loginView(navigator: LoginViewNavigatorProtocol) -> LoginView {
        Container.Login.view(navigator)
    }

    static func resetPasswordView(navigator: ResetPasswordViewNavigatorProtocol) -> ResetPasswordView {
        Container.PasswordReset.view(navigator)
    }

    static func confirmResetPasswordView(navigator: RegisterVerificationViewNavigatorProtocol, username: String) -> ConfirmResetPasswordView {
        Container.PasswordResetConfirmation.view((navigator, username))
    }

    static func updatePasswordView(navigator: ChangePasswordViewNavigatorProtocol) -> ChangePasswordView {
        Container.PasswordUpdate.view(navigator)
    }

    static func registerView(navigator: RegisterViewNavigatorProtocol) -> RegisterView {
        Container.Register.view(navigator)
    }

    static func registerVerificationView(navigator: RegisterVerificationViewNavigatorProtocol) -> VerifyView {
        Container.RegisterVerify.view(navigator)
    }

    static func profileView(navigator: ProfileViewNavigatorProtocol) -> ProfileView {
        Container.Profile.view(navigator)
    }

    static func profileNavigator() -> ProfileNavigator {
        Container.Profile.navigator()
    }

    // MARK: - SOCIAL

    static func socialView(navigator: SocialListViewNavigatorProtocol) -> SocialView {
        Container.Social.view(navigator)
    }

    static func socialNavigator() -> SocialNavigator {
        Container.Social.navigator()
    }

    static func friendRequestView() -> FriendRequestView {
        Container.FriendRequest.view()
    }

    static func friendAddView(navigator: SocialAddViewNavigatorProtocol) -> FriendAddView {
        Container.FriendAdd.view(navigator)
    }

    static func powderTrackrChatView(chatId: String) -> PowderTrackrChatView {
        Container.Chat.view(chatId)
    }

    // MARK: - MAP
    static func googleMap(
        cameraPos: Binding<GMSCameraPosition>,
        selectedPath: Binding<TrackedPath?>,
        shared: Binding<Bool>
    ) -> GoogleMapsView {
        Container.GoogleMap.view((cameraPos, selectedPath, shared))
    }

    static func mapView() -> MapView {
        Container.Map.view()
    }

    // MARK: - Tracklist

    static func trackListView() -> TrackListView {
        Container.TrackList.view()
    }
}
