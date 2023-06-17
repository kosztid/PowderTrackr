import SwiftUI

struct FriendRequestView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.friendRequests) { request in
                    FriendRequestRowView(requester: request.senderEmail, action: {
                        viewModel.addFriend(request: request)
                    })
                }
            }
        }
        .refreshable {
            viewModel.refreshRequests()
        }
    }
}

public struct FriendRequestRowView: View {
    var requester: String
    let action: () -> Void

    public var body: some View {
        HStack {
            Text(requester)
            Spacer()
            Button {
                action()
            } label: {
                Text("Accept")
            }
        }
        .padding(20)
    }
}
