import ExyteChat
import SwiftUI

public struct PowderTrackrChatView: View {
    @StateObject var viewModel: ViewModel

    public var body: some View {
        ChatView(messages: viewModel.messages) { message in
            viewModel.sendMessage(draftMessage: message)
        } inputViewBuilder: { textBinding, attachments, state, style, actionClosure, _  in
            Group {
                switch style {
                case .message:
                    HStack {
                        TextField("Write your message", text: textBinding)
                        HStack {
                            Button {
                                actionClosure(.send)
                            } label: {
                                Image(systemName: "paperplane")
                                    .frame(width: .su48, height: .su48)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.leading, .su16)
                    .background(.white)
                    .cornerRadius(.su16, corners: [.topLeft, .topRight])
                    .shadow(
                        color: .gray.opacity(0.2),
                        radius: .su4,
                        x: .zero,
                        y: -.su4
                    )
                case .signature:
                    HStack {
                        TextField("Write your message", text: textBinding)
                        HStack {
                            Button {
                                actionClosure(.send)
                            } label: {
                                Image(systemName: "paperplane")
                                    .frame(width: .su48, height: .su48)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.leading, .su16)
                    .background(.white)
                    .cornerRadius(.su16, corners: [.topLeft, .topRight])
                    .shadow(
                        color: .gray.opacity(0.2),
                        radius: .su4,
                        x: .zero,
                        y: -.su4
                    )
                }
            }
        }
        .mediaPickerTheme(
            main: .init(
                text: .black,
                albumSelectionBackground: .white,
                fullscreenPhotoBackground: .white
            ),
            selection: .init(
                emptyTint: .white,
                emptyBackground: .black.opacity(0.25),
                selectedTint: .blue,
                fullscreenTint: .white
            )
        )
        .onDisappear(perform: viewModel.stopTimer)
        .onAppear(perform: viewModel.startTimer)
    }
}

struct PowderTrackrChatView_Previews: PreviewProvider {
    static var previews: some View {
        PowderTrackrChatView(viewModel: .init(chatService: ChatService(), model: .init(chatId: "", names: [])))
    }
}
