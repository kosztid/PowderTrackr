import SwiftUI

struct ResetPasswordView: View {
    private typealias Str = Rsc.ResetPasswordView

    @StateObject var viewModel: ViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                Text(Str.Username.description)
                    .textStyle(.body)
                    .foregroundColor(.gray)
                    .padding(.vertical, .su32)
                TextField(text: $viewModel.username)
                    .regularTextFieldStyle(label: Str.username)
                    .padding(.bottom, .su16)
                Button(Str.Button.reset) {
                    viewModel.reset()
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
            }
            .floatingRoundedCardBackground()
            .padding(.vertical, .su16)
            .padding(.horizontal, .su8)
        }
        .toastMessage(toastMessage: $viewModel.toast)
        .headerView(description: Str.Header.description)
        .background(Color.grayPrimary)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.navigateBack()
                } label: {
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
