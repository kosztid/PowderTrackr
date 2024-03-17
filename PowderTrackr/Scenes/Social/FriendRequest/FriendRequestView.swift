import SwiftUI

struct FriendRequestView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.friendRequests) { request in
                    FriendRequestRowView(
                        requester: request.sender.name,
                        acceptAction: { viewModel.acceptRequest(request) },
                        declineAction: { viewModel.declineRequest(request) }
                    )
                }
            }
        }
        .background(Color.grayPrimary)
        .refreshable {
            viewModel.refreshRequests()
        }
    }
}


