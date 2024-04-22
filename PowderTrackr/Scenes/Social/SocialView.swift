import SwiftUI

public struct SocialView: View {
    @StateObject var viewModel: ViewModel
    
    public var body: some View {
        VStack(spacing: .zero) {
            notificationSection
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
            VStack {
                if !viewModel.signedIn {
                    LoggedOutModal {
                        viewModel.inputModel.navigateToAccount()
                    }
                } else {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewModel.navigateToAddFriend()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: .su16, height: .su16)
                                .padding(.vertical, .su24)
                        }
                        .buttonStyle(SkiingButtonStyle(style: .secondary))
                        .cornerRadius(.su32)
                        .customShadow()
                    }
                    .padding()
                }
            }
            
        }
        .onAppear { viewModel.onAppear() }
        .toolbar(.hidden)
    }
    
    private var segmentedControl: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "Friends")) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.friendList?.friends ?? []) { friend in
                            FriendListItem(
                                friend: friend,
                                notification: viewModel.notification(for: friend.id),
                                lastMessage: viewModel.lastMessage(for: friend.id)
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
    
    @ViewBuilder private var notificationSection: some View {
        if viewModel.notification {
            InfoCardView(
                model: .init(
                    message: "You have a new friendrequest(s)",
                    bottomActionButton: .init(
                        title: "Requests",
                        action: viewModel.navigateToRequests
                    )
                ),
                style: .info
            )
            .padding(.horizontal, .su16)
        }
    }
}

struct SocialView_Preview: PreviewProvider {
    static var previews: some View {
        ViewFactory.socialNavigator({})
    }
}


