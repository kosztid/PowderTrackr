import SwiftUI

struct SocialView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.navigateToRequests()
                } label: {
                    viewModel.notification ? Image(systemName: "bell.badge.fill") : Image(systemName: "bell.fill")
                }
                Spacer()
                Button {
                    viewModel.navigateToAddFriend()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .padding(.horizontal, 16)
            segmentedControl
        }
        .overlay {
            if !viewModel.signedIn {
                LoggedOutModal()
            }
        }
        .onAppear { viewModel.onAppear() }
        .toolbar(.hidden)
    }
    
    var segmentedControl: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "Friends")) {
                ZStack {
                    List {
                        ForEach(viewModel.friendList?.friends ?? []) { friend in
                            FriendListItem(
                                friend: friend,
                                notification: viewModel.notification(for: friend.id)
                            ) {
                                viewModel.updateTracking(id: friend.id)
                            } navigationAction: {
                                viewModel.navigateToChatWithFriend(friendId: friend.id)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.removeFriend(friend: friend)
                                } label: {
                                    Text("Delete")
                                }
                            }
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
                                .onTapGesture(perform: {
                                    viewModel.navigateToChatGroup(groupId: "group")
                                })
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        )
    }
}

