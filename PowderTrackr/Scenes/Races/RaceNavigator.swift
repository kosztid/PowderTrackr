import FlowStacks
import SwiftUI

public enum RacesScreen {
    case races
    case raceRuns
    case myRuns(String)
}

protocol RacesViewNavigatorProtocol {
    func navigateToRaceRuns(race: String)
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
            case .raceRuns: ViewFactory.raceRunView()
            case .myRuns(let race): ViewFactory.myRunsView(race: race)
            }
        }
    }

    public init() {
        self.routes = [.root(.races, embedInNavigationView: true)]
    }
}

extension RaceNavigator: RacesViewNavigatorProtocol {
    func navigateToRaceRuns(race: String) {
        routes.push(.myRuns(race))
    }
}

extension RaceNavigator: RaceRunViewNavigatorProtocol {
    func navigateBack() {
        routes.dismiss()
    }
}
