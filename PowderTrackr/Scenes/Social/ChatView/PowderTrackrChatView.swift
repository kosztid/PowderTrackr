import Chat
import SwiftUI

struct PowderTrackrChatView: View {
    var body: some View {
        ChatView(messages: [.init(id: "123", user: User(id: "123", name: "Dominik", avatarURL: nil, isCurrentUser: true), text: "Szia"), .init(id: "124", user: User(id: "124", name: "Koszti", avatarURL: nil, isCurrentUser: false), text: "Hali")]) { _ in
        }
    }
}

struct PowderTrackrChatView_Previews: PreviewProvider {
    static var previews: some View {
        PowderTrackrChatView()
    }
}
