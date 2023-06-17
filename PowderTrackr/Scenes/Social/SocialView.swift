import SwiftUI

struct SocialView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            List { /* 1 */
                ForEach(viewModel.friendList?.friends ?? []) { friend in
                    FriendListItem(friend: friend) {
                        viewModel.updateTracking(id: friend.id)
                    }
                    .listRowSeparator(.hidden)
                }
                .onDelete(perform: viewModel.delete)
            }
            .listStyle(.plain)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.navigateToRequests()
                } label: {
                    viewModel.notification ? Image(systemName: "bell.badge.fill") : Image(systemName: "bell.fill")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.navigateToAddFriend()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
