import SwiftUI

extension PowderTrackrView {
    final class ViewModel: ObservableObject {
        private let navigator: PowderTrackrViewNavigatorProtocol
        
        init(navigator: PowderTrackrViewNavigatorProtocol) {
            self.navigator = navigator
        }
        
        func accountButtonTap() {
            navigator.navigateToAccount()
        }
    }
}
