import Chat
import SwiftUI

struct PowderTrackrChatView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ChatView(messages: viewModel.messages) { message in
            viewModel.sendMessage(draftMessage: message)
        } inputViewBuilder: { textBinding, attachments, state, style, actionClosure in
            Group {
                switch style {
                case .message:
                    HStack {
                        TextField("Write your message", text: textBinding)
                        HStack {
                            Button {
                                actionClosure(.photo)
                            } label: {
                                Image(systemName: "photo.on.rectangle")
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(.gray)
                            }
                            Button {
                                actionClosure(.send)
                            } label: {
                                Image(systemName: "paperplane")
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.leading, 16)
                    .background(.white)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .shadow(
                        color: .gray.opacity(0.2),
                        radius: 4,
                        x: 0,
                        y: -4
                    )
                case .signature:
                    VStack {
                        HStack {
                            Button("Send") { actionClosure(.send) }
                        }
                        TextField("Compose a signature for photo", text: textBinding)
                            .background(Color.green)
                    }
                }
            }
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
