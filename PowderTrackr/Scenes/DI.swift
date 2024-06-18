import Factory

extension Container {
    enum PowderTrackr {
        static let view = ParameterFactory { navigator in
            PowderTrackrView(viewModel: .init(navigator: navigator))
        }

        static let viewModel = ParameterFactory { navigator in
            PowderTrackrView.ViewModel(navigator: navigator)
        }

        static let navigator = Factory {
            PowderTrackrNavigator()
        }
    }

    enum TabBar {
        static let view = ParameterFactory { openAccount in
            TabBarNavigator(openAccount: openAccount)
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
        static let view = ParameterFactory { navigator, model in
            VerifyView(
                viewModel: viewModel((navigator, model))
            )
        }

        static let viewModel = ParameterFactory { navigator, model in
            VerifyView.ViewModel(
                navigator: navigator,
                accountService: accountService(),
                inputModel: model
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

        static let navigator = ParameterFactory { navigateBack in
            ProfileNavigator(dismissNavigator: navigateBack)
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
        static let view = ParameterFactory { navigator, model in
            SocialView(
                viewModel: viewModel((navigator, model))
            )
        }

        static let viewModel = ParameterFactory { navigator, model in
            SocialView.ViewModel(
                navigator: navigator,
                friendService: friendService(),
                accountService: accountService(),
                chatService: chatService(),
                inputModel: model
            )
        }

        static let navigator = ParameterFactory { openAccount in
            SocialNavigator(openAccount: openAccount)
        }
    }

    // MARK: - CHAT
    enum Chat {
        static let view = ParameterFactory { inputModel in
            PowderTrackrChatView(viewModel: viewModel(inputModel))
        }

        static let viewModel = ParameterFactory { inputModel in
            PowderTrackrChatView.ViewModel(chatService: chatService(), model: inputModel)
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
        static let view = ParameterFactory { navigator, model in
            FriendAddView(viewModel: viewModel((navigator, model)))
        }

        static let viewModel = ParameterFactory { navigator, model in
            FriendAddView.ViewModel(navigator: navigator, service: friendService(), model: model)
        }
    }

    enum TrackList {
        static let view = ParameterFactory { model in
            TrackListView(viewModel: viewModel(model))
        }

        static let viewModel = ParameterFactory { model in
            TrackListView.ViewModel(mapService: mapService(), accountService: accountService(), friendService: friendService(), inputModel: model)
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
        static let view = ParameterFactory { navigator, model in
            RacesView(viewModel: viewModel((navigator, model)))
        }

        static let viewModel = ParameterFactory { navigator, model in
            RacesView.ViewModel(
                mapService: mapService(),
                friendService: friendService(),
                accountService: accountService(),
                navigator: navigator,
                inputModel: model
            )
        }

        static let navigator = ParameterFactory { openAccount in
            RaceNavigator(openAccount: openAccount)
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
