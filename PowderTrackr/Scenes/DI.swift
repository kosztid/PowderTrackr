import Factory

extension Container {
    enum PowderTrackr {

        static let view = Factory {
            PowderTrackrView()
        }
    }

    enum TabBar {
        static let view = Factory {
            TabBarNavigator()
        }
    }

    enum Login {
        static let view = ParameterFactory { navigator in
            LoginView(
                viewModel: viewModel(navigator)
            )
        }

        static let viewModel = ParameterFactory { navigator in
            LoginView.ViewModel(
                navigator: navigator,
                accountService: accountService()
            )
        }
    }

    enum Register {
        static let view = ParameterFactory { navigator in
            RegisterView(
                viewModel: viewModel(navigator)
            )
        }

        static let viewModel = ParameterFactory { navigator in
            RegisterView.ViewModel(
                navigator: navigator,
                accountService: accountService()
            )
        }
    }

    enum PasswordReset {
        static let view = ParameterFactory { navigator in
            ResetPasswordView(
                viewModel: viewModel(navigator)
            )
        }
        static let viewModel = ParameterFactory { navigator in
            ResetPasswordView.ViewModel(
                navigator: navigator,
                accountService: accountService()
            )
        }
    }

    enum PasswordResetConfirmation {
        static let view = ParameterFactory { navigator, username in
            ConfirmResetPasswordView(
                viewModel: viewModel((navigator, username))
            )
        }
        static let viewModel = ParameterFactory { navigator, username in
            ConfirmResetPasswordView.ViewModel(
                navigator: navigator,
                accountService: accountService(),
                username: username
            )
        }
    }

    enum PasswordUpdate {
        static let view = ParameterFactory { navigator in
            ChangePasswordView(viewModel: viewModel(navigator))
        }

        static let viewModel = ParameterFactory { navigator in
            ChangePasswordView.ViewModel(
                navigator: navigator,
                accountService: accountService()
            )
        }
    }

    enum RegisterVerify {
        static let view = ParameterFactory { navigator in
            VerifyView(
                viewModel: viewModel(navigator)
            )
        }

        static let viewModel = ParameterFactory { navigator in
            VerifyView.ViewModel(
                navigator: navigator,
                accountService: accountService()
            )
        }
    }

    // MARK: - PROFILE
    enum Profile {
        static let view = ParameterFactory { navigator in
            ProfileView(
                viewModel: viewModel(navigator)
            )
        }

        static let viewModel = ParameterFactory { navigator in
            ProfileView.ViewModel(
                navigator: navigator,
                accountService: accountService(),
                mapService: mapService()
            )
        }

        static let navigator = Factory {
            ProfileNavigator()
        }
    }

    // MARK: - MAP
    enum GoogleMap {
        static let view = ParameterFactory { cameraPos, selectedPath, selectedRace, shared, cameraPosChanged, raceMarkers in
            GoogleMapsView(
                cameraPos: cameraPos,
                selectedPath: selectedPath,
                selectedRace: selectedRace,
                shared: shared,
                cameraPosChanged: cameraPosChanged,
                raceMarkers: raceMarkers
            )
        }
    }

    enum Map {
        static let view = Factory {
            MapView(viewModel: viewModel())
        }

        static let viewModel = Factory {
            MapView.ViewModel(
                accountService: accountService(),
                mapService: mapService(),
                friendService: friendService()
            )
        }
    }

    // MARK: - SOCIAL
    enum Social {
        static let view = ParameterFactory { navigator in
            SocialView(
                viewModel: viewModel(navigator)
            )
        }

        static let viewModel = ParameterFactory { navigator in
            SocialView.ViewModel(
                navigator: navigator,
                friendService: friendService(),
                accountService: accountService(),
                chatService: chatService()
            )
        }

        static let navigator = Factory {
            SocialNavigator()
        }
    }

    // MARK: - CHAT
    enum Chat {
        static let view = ParameterFactory { chatId in
            PowderTrackrChatView(viewModel: viewModel(chatId))
        }

        static let viewModel = ParameterFactory { chatId in
            PowderTrackrChatView.ViewModel(chatService: chatService(), chatID: chatId)
        }
    }

    enum FriendRequest {
        static let view = Factory {
            FriendRequestView(viewModel: viewModel())
        }

        static let viewModel = Factory {
            FriendRequestView.ViewModel(service: friendService())
        }
    }

    enum FriendAdd {
        static let view = ParameterFactory { navigator in
            FriendAddView(viewModel: viewModel(navigator))
        }

        static let viewModel = ParameterFactory { navigator in
            FriendAddView.ViewModel(navigator: navigator, service: friendService())
        }
    }

    enum TrackList {
        static let view = Factory {
            TrackListView(viewModel: viewModel())
        }

        static let viewModel = Factory {
            TrackListView.ViewModel(mapService: mapService(), accountService: accountService(), friendService: friendService())
        }
    }

    enum LeaderBoard {
        static let view = Factory {
            LeaderBoardView(viewModel: viewModel())
        }

        static let viewModel = Factory {
            LeaderBoardView.ViewModel(statservice: statisticsService())
        }
    }

    enum Races {
        static let view = ParameterFactory { navigator in
            RacesView(viewModel: viewModel(navigator))
        }

        static let viewModel = ParameterFactory { navigator in
            RacesView.ViewModel(
                mapService: mapService(),
                friendService: friendService(),
                accountService: accountService(),
                navigator: navigator
            )
        }

        static let navigator = Factory {
            RaceNavigator()
        }
    }

    enum RaceRun {
        static let view = ParameterFactory { race, closestRun in
            RaceRunView(viewModel: viewModel((race, closestRun)))
        }

        static let viewModel = ParameterFactory { race, closestRun in
            RaceRunView.ViewModel(closestRun: closestRun, race: race)
        }
    }

    enum RaceRunGoogleMap {
        static let view = ParameterFactory { cameraPos, raceMarkers in
            RaceRunGoogleMapsView(
                cameraPos: cameraPos,
                raceMarkers: raceMarkers
            )
        }
    }

    enum MyRuns {
        static let view = ParameterFactory { runs in
            MyRunsView(viewModel: viewModel((runs)))
        }

        static let viewModel = ParameterFactory { runs in
            MyRunsView.ViewModel(race: runs, accountService: accountService())
        }
    }
}
