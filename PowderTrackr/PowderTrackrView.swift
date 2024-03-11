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
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            ViewFactory.tabBarView(viewModel.accountButtonTap)
        }
    }
}
