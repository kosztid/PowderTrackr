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
                            .onTapGesture(perform: {
                                viewModel.navigateToChat()
                            })
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            },
            secondTab: .init(tabItem: .init(name: "Groups")) {
                ZStack {
                    List {
                        ForEach(viewModel.groupList, id: \.self) { group in
                            GroupListItem()
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        )
        .overlay {
            if !viewModel.signedIn {
                LoggedOutModal()
            }
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

