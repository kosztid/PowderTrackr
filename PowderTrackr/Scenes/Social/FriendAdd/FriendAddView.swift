import SwiftUI

public struct FriendAddView: View {
    @StateObject var viewModel: ViewModel
    public var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.users, id: \.self) { user in
                    Text(user.name)
                }
            }
        }
        .toastMessage(toastMessage: $viewModel.toast)
        .headerView(title: "Add friends to ski with", style: .inline)
    }
}
