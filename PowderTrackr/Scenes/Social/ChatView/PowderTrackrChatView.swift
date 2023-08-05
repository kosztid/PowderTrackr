import Chat
import SwiftUI

struct PowderTrackrChatView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ChatView(messages: viewModel.messages) { message in
            viewModel.sendMessage(draftMessage: message)
        }
        .mediaPickerTheme(
            main: .init(
                text: .white,
                albumSelectionBackground: .black,
                fullscreenPhotoBackground: .black
            ),
            selection: .init(
                emptyTint: .white,
                emptyBackground: .black.opacity(0.25),
                selectedTint: .blue,
                fullscreenTint: .white
            )
        )
    }
}

struct PowderTrackrChatView_Previews: PreviewProvider {
    static var previews: some View {
        PowderTrackrChatView(viewModel: .init(chatService: ChatService(), chatID: ""))
    }
}
