import SwiftUI

public struct SocialView: View {
    @StateObject var viewModel: ViewModel
    
    public var body: some View {
        VStack(spacing: .su16) {
            notificationSection
            friendsList
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
    
    private var friendsList: some View {
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


