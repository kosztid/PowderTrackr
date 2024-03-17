import SwiftUI

public struct FriendListItem: View {
    var friend: Friend
    var notification: Bool
    @State var isTracking: Bool
    let action: () -> Void
    let navigationAction: () -> Void

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                Text(lastMessageDescription)
                    .font(.subheadline)
                    .foregroundColor(notification ? .blueSecondary : .warmGray)
            }
            .padding(.leading, 10)

            Spacer()

            Toggle(isOn: $isTracking) {
            }
            .toggleStyle(SwitchToggleStyle(tint: .blueSecondary))
            .labelsHidden()
            .padding(.trailing, 8)
        }
        .onChange(of: isTracking) {
            action()
        }
        .frame(height: 60)
        .background(Color.softWhite)
        .cornerRadius(12)
        .customShadow(style: .light)
        .onTapGesture {
            navigationAction()
        }
        .padding(.horizontal, 16)
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
