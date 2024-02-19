import FlowStacks
import SwiftUI

public enum RacesScreen {
    case races
    case raceRuns
    case myRuns(Race)
}

protocol RacesViewNavigatorProtocol {
    func navigateToRaceRuns(race: Race)
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
            case .myRuns(let runs): ViewFactory.myRunsView(runs: runs)
            }
        }
    }

    public init() {
        self.routes = [.root(.races, embedInNavigationView: false)]
    }
}

extension RaceNavigator: RacesViewNavigatorProtocol {
    func navigateToRaceRuns(race: Race) {
        routes.push(.myRuns(race))
    }
}

extension RaceNavigator: RaceRunViewNavigatorProtocol {
    func navigateBack() {
        routes.dismiss()
    }
}
