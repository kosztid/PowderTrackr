import SwiftUI

extension RacesView {
    final class ViewModel: ObservableObject {
        private let navigator: RacesViewNavigatorProtocol

        init(navigator: RacesViewNavigatorProtocol) {
            self.navigator = navigator
        }

        func navigateToMyRuns(race: String) {
            navigator.navigateToRaceRuns(race: race)
        }
    }
}
