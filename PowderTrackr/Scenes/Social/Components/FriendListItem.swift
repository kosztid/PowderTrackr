import SwiftUI

public struct FriendListItem: View {
    var friend: Friend
    @State var isTracking: Bool
    let action: () -> Void

    public var body: some View {
        HStack {
            Text(friend.name)
            Spacer()
            Toggle(isOn: $isTracking) {
            }
        }
        .onChange(of: isTracking) { _ in
            action()
        }
        .padding(.horizontal, 20)
    }

    public init(friend: Friend, isTracking: Bool = false, action: @escaping () -> Void) {
        self.friend = friend
        self.isTracking = .init(friend.isTracking)
        self.action = action
    }
}
