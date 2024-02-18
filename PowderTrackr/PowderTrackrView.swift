import Factory
import SwiftUI

struct PowderTrackrView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("PowderTrackr")
                    .bold()
                Spacer()
                Button {
                    viewModel.accountButtonTap()
                } label: {
                    Image(systemName: "person.3.fill")
                }
            }
            .padding(16)
            ViewFactory.tabBarView()
        }
    }
}
