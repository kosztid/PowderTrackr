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

    enum GoogleMap {
        static let view = ParameterFactory { cameraPos, selectedPath in
            GoogleMapsView(
                cameraPos: cameraPos,
                selectedPath: selectedPath
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

    enum Social {
        static let view = ParameterFactory { navigator in
            SocialView(
                viewModel: viewModel(navigator)
            )
        }

        static let viewModel = ParameterFactory { navigator in
            SocialView.ViewModel(navigator: navigator, friendService: friendService())
        }

        static let navigator = Factory {
            SocialNavigator()
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
            TrackListView.ViewModel(mapService: mapService())
        }
    }
}
