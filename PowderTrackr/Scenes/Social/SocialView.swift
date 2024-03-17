import SwiftUI

struct SocialView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
//            HStack {
//                Button {
//                    viewModel.navigateToRequests()
//                } label: {
//                    viewModel.notification ? Image(systemName: "bell.badge.fill") : Image(systemName: "bell.fill")
//                }
//                Spacer()
//                Button {
//                    viewModel.navigateToAddFriend()
//                } label: {
//                    Image(systemName: "plus")
//                }
//            }
//            .padding(16)
            segmentedControl
        }
        .background(Color.grayPrimary)
        .overlay {
            if !viewModel.signedIn {
                LoggedOutModal {
                    viewModel.inputModel.navigateToAccount()
                }
            }
        }
        .onAppear { viewModel.onAppear() }
        .toolbar(.hidden)
    }
    
    var segmentedControl: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "Friends")) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.friendList?.friends ?? []) { friend in
                            FriendListItem(
                                friend: friend,
                                notification: viewModel.notification(for: friend.id)
                            ) {
                                viewModel.updateTracking(id: friend.id)
                            } navigationAction: {
                                viewModel.navigateToChatWithFriend(friendId: friend.id, friendName: friend.name)
                            }
                        }
                    }
                }
                .background(Color.grayPrimary)
            },
            secondTab: .init(tabItem: .init(name: "Groups")) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.groupList, id: \.self) { group in
                            GroupListItem()
                                .onTapGesture(perform: {
                                    viewModel.navigateToChatGroup(groupId: "group")
                                })
                                .listRowSeparator(.hidden)
                        }
                    }
                }
                .background(Color.grayPrimary)
            }
        )
    }
}

