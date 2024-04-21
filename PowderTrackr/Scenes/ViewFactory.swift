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
    
    static func tabBarView(_ openAccount: @escaping () -> Void) -> TabBarNavigator {
        Container.TabBar.view(openAccount)
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

    static func socialView(navigator: SocialListViewNavigatorProtocol, model: SocialView.InputModel) -> SocialView {
        Container.Social.view((navigator, model))
    }

    static func socialNavigator(_ openAccount: @escaping () -> Void) -> SocialNavigator {
        Container.Social.navigator(openAccount)
    }

    static func raceNavigator(_ openAccount: @escaping () -> Void) -> RaceNavigator {
        Container.Races.navigator(openAccount)
    }

    static func friendRequestView() -> FriendRequestView {
        Container.FriendRequest.view()
    }

    static func friendAddView(navigator: SocialAddViewNavigatorProtocol, model: FriendAddView.InputModel) -> FriendAddView {
        Container.FriendAdd.view((navigator, model))
    }

    static func powderTrackrChatView(model: PowderTrackrChatView.InputModel) -> PowderTrackrChatView {
        Container.Chat.view(model)
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

    static func trackListView(model: TrackListView.InputModel) -> TrackListView {
        Container.TrackList.view(model)
    }

    // MARK: - LeaderBoard

    static func leaderBoardView() -> LeaderBoardView {
        Container.LeaderBoard.view()
    }

    // MARK: - Races

    static func racesView(navigator: RacesViewNavigatorProtocol, inputModel: RacesView.InputModel) -> RacesView {
        Container.Races.view((navigator, inputModel))
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
