import SwiftUI

struct SocialView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "Friends")) {
                ZStack {
                    List {
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
                .onAppear {
                    print(viewModel.friendList?.friends)
                }
            },
            secondTab: .init(tabItem: .init(name: "Groups")) {
                VStack {
                    Text("group1")
                    Text("group2")
                    Text("group3")
                }
            }
        )
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

