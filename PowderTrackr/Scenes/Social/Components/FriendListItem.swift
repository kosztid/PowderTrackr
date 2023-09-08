import SwiftUI

public struct FriendListItem: View {
    var friend: Friend
    var notification: Bool
    @State var isTracking: Bool
    let action: () -> Void
    let navigationAction: () -> Void

    public var body: some View {
        HStack {
            Text(friend.name)
                .fontWeight(notification ? .bold : .regular)
                .onTapGesture {
                    navigationAction()
                }
            Spacer()
            if notification {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 12, height: 12)
                    .padding(.horizontal, 8)
            }
            Toggle(isOn: $isTracking) {
            }
            .frame(width: 40)

        }
        .onChange(of: isTracking) { _ in
            action()
        }
        .padding(.horizontal, 20)
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
