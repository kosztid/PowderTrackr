import SwiftUI

public struct FriendListItem: View {
    var friend: Friend
    var notification: Bool
    @State var isTracking: Bool
    let action: () -> Void
    let navigationAction: () -> Void

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: .su4) {
                Text(friend.name)
                    .textStyle(.bodyLargeBold)
                    .foregroundColor(.primary)
                Text(lastMessageDescription)
                    .textStyle(.body)
                    .foregroundColor(notification ? .blueSecondary : .warmGray)
            }

            Spacer()

            Toggle(isOn: $isTracking) {
            }
            .toggleStyle(SwitchToggleStyle(tint: .blueSecondary))
            .labelsHidden()
        }
        .onChange(of: isTracking) {
            action()
        }
        .onTapGesture {
            navigationAction()
        }
        .frame(height: .su64)
        .floatingRoundedCardBackground()
    }
    
    var lastMessageDescription: String {
        if notification {
            return "chatItem.lastMessage"
        } else {
            return "You: ".appending("Ez az utolsó üzenet")
        }
    }

    public init(
        friend: Friend,
        notification: Bool = false,
        isTracking: Bool = false,
        action: @escaping () -> Void,
        navigationAction: @escaping () -> Void
    ) {
        self.friend = friend
        self.notification = notification
        self.isTracking = .init(friend.isTracking)
        self.action = action
        self.navigationAction = navigationAction
    }
}

struct FriendListItem_Previews: PreviewProvider {
    static var previews: some View {
        FriendListItem(friend: .init(id: "123", name: "Dominik", isTracking: true), notification: true, action: {}, navigationAction: {})
    }
}
