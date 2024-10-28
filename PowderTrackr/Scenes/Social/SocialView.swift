import SwiftUI

public struct SocialView: View {
    private typealias Str = Rsc.SocialView

    @StateObject var viewModel: ViewModel

    public var body: some View {
        VStack(spacing: .su16) { /* 1 */
            notificationSection
            friendsList
        }
        .onAppear { viewModel.onAppear() }
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
    }

    private var friendsList: some View {
        List {
            ForEach(viewModel.friendList?.friends ?? [], id: \.id) { friend in
                FriendListItem(
                    friend: friend,
                    notification: viewModel.notification(for: friend.id),
                    lastMessage: viewModel.lastMessage(for: friend.id)
                ) {
                    viewModel.updateTracking(id: friend.id)
                } navigationAction: {
                    viewModel.navigateToChatWithFriend(friendId: friend.id, friendName: friend.name)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.removeFriend(friend: friend)
                    } label: {
                        Label(Str.SwipeToDelete.label, systemImage: "trash")
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.grayPrimary)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.grayPrimary)
    }

    @ViewBuilder private var notificationSection: some View {
        if viewModel.notification {
            InfoCardView(
                model: .init(
                    message: Str.Infocard.message,
                    bottomActionButton: .init(
                        title: Str.Infocard.buttonTitle,
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
