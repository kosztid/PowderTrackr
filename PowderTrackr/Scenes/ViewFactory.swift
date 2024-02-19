import Factory
import GoogleMaps
import SwiftUI

enum ViewFactory {
    static func powderTrackrView(navigator: PowderTrackrViewNavigatorProtocol) -> PowderTrackrView {
        Container.PowderTrackr.view(navigator)
    }
    
    static func powderTrackrNavigator() -> PowderTrackrNavigator {
        Container.PowderTrackr.navigator()
    }
    
    static func tabBarView() -> TabBarNavigator {
        Container.TabBar.view()
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

    static func profileNavigator(navigateBack: @escaping () -> Void) -> ProfileNavigator {
        Container.Profile.navigator(navigateBack)
    }

    // MARK: - SOCIAL

    static func socialView(navigator: SocialListViewNavigatorProtocol) -> SocialView {
        Container.Social.view(navigator)
    }

    static func socialNavigator() -> SocialNavigator {
        Container.Social.navigator()
    }

    static func raceNavigator() -> RaceNavigator {
        Container.Races.navigator()
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
        selectedRace: Binding<Race?>,
        shared: Binding<Bool>,
        cameraPosChanged: Binding<Bool>,
        raceMarkers: Binding<[GMSMarker]>
    ) -> GoogleMapsView {
        Container.GoogleMap.view((cameraPos, selectedPath, selectedRace, shared, cameraPosChanged, raceMarkers))
    }

    static func mapView() -> MapView {
        Container.Map.view()
    }

    // MARK: - Tracklist

    static func trackListView() -> TrackListView {
        Container.TrackList.view()
    }

    // MARK: - LeaderBoard

    static func leaderBoardView() -> LeaderBoardView {
        Container.LeaderBoard.view()
    }

    // MARK: - Races

    static func racesView(navigator: RacesViewNavigatorProtocol) -> RacesView {
        Container.Races.view(navigator)
    }

    static func raceRunView(closestRun: TrackedPath, race: TrackedPath) -> RaceRunView {
        Container.RaceRun.view((race, closestRun))
    }

    static func myRunsView(runs: Race) -> MyRunsView {
        Container.MyRuns.view((runs))
    }

    static func raceRunGoogleMap(
        cameraPos: Binding<GMSCameraPosition>,
        raceMarkers: Binding<[GMSMarker]>
    ) -> RaceRunGoogleMapsView {
        Container.RaceRunGoogleMap.view((cameraPos, raceMarkers))
    }
}
