import Factory
import SwiftUI

struct PowderTrackrView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("PowderTrackr")
                    .textStyle(.bodyLargeBold)
                Spacer()
                Button {
                    viewModel.accountButtonTap()
                } label: {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: .su20, height: .su20)
                }
            }
            .padding(.horizontal, .su16)
            .padding(.vertical, .su4)
            .background(Color.grayPrimary)
            ViewFactory.tabBarView(viewModel.accountButtonTap)
        }
    }
}
