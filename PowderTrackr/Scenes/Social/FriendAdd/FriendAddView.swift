import SwiftUI

struct FriendAddView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        VStack {
            Text("Add a friend to ski with")
                .font(.largeTitle)
                .padding(.vertical, .su40)
            TextField(text: $viewModel.email)
                .regularTextFieldStyle(label: "Username")
                .padding(.bottom, .su20)
            Button {
                viewModel.addFriend()
            } label: {
                Text("Add")
            }
            .buttonStyle(SkiingButtonStyle())
            Spacer()
        }
        .padding(.horizontal, .su32)
    }
}
