import SwiftUI

extension RaceManageItemView {
    final class ViewModel: ObservableObject {
        @Published var race: String

        init(race: String) {
            self.race = race
        }
    }
}
