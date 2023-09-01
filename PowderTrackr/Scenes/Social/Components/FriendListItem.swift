import SwiftUI

public struct FriendListItem: View {
    var friend: Friend
    var message: Bool
    @State var isTracking: Bool
    let action: () -> Void

    public var body: some View {
        HStack {
            Text(friend.name)
            if message {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 8, height: 8)
                    .padding(.horizontal, 8)
            }
            Spacer()
            Toggle(isOn: $isTracking) {
            }
        }
        .onChange(of: isTracking) { _ in
            action()
        }
        .padding(.horizontal, 20)
    }

    public init(friend: Friend, message: Bool = false, isTracking: Bool = false, action: @escaping () -> Void) {
        self.friend = friend
        self.message = message
        self.isTracking = .init(friend.isTracking)
        self.action = action
    }
}

struct FriendListItem_Previews: PreviewProvider {
    static var previews: some View {
        FriendListItem(friend: .init(id: "123", name: "Dominik", isTracking: true), action: {})
    }
}
