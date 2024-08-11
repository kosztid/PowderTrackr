import FlowStacks
import SwiftUI

public enum RacesScreen {
    case races
    case raceRuns
    case myRuns(Race)
}

// sourcery: mock
protocol RacesViewNavigatorProtocol {
    func navigateToRaceRuns(race: Race)
}

// sourcery: mock
protocol RaceRunViewNavigatorProtocol {
    func navigateBack()
}

public struct RaceNavigator: Navigator {
    @State var routes: Routes<RacesScreen>
    let openAccount: () -> Void

    public var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .races: ViewFactory.racesView(navigator: self, inputModel: .init(navigateToAccount: openAccount))
            case .raceRuns: EmptyView()
            case .myRuns(let runs): ViewFactory.myRunsView(runs: runs)
            }
        }
    }

    public init(openAccount: @escaping () -> Void) {
        self.openAccount = openAccount
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
