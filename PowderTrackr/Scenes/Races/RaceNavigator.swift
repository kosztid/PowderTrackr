import FlowStacks
import SwiftUI

public enum RacesScreen {
    case races
    case raceRuns
    case myRuns([TrackedPath], String)
}

protocol RacesViewNavigatorProtocol {
    func navigateToRaceRuns(runs: [TrackedPath], title: String)
}

protocol RaceRunViewNavigatorProtocol {
    func navigateBack()
}

public struct RaceNavigator: Navigator {
    @State var routes: Routes<RacesScreen>

    public var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .races: ViewFactory.racesView(navigator: self)
            case .raceRuns: EmptyView()
            case .myRuns(let runs, let title): ViewFactory.myRunsView(runs: runs, title: title)
            }
        }
    }

    public init() {
        self.routes = [.root(.races, embedInNavigationView: true)]
    }
}

extension RaceNavigator: RacesViewNavigatorProtocol {
    func navigateToRaceRuns(runs race: [TrackedPath], title: String) {
        routes.push(.myRuns(race, title))
    }
}

extension RaceNavigator: RaceRunViewNavigatorProtocol {
    func navigateBack() {
        routes.dismiss()
    }
}
