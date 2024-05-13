import SwiftUI

struct ResetPasswordView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                Text("Please type in your username to reset your password.")
                    .textStyle(.body)
                    .foregroundColor(.gray)
                    .padding(.vertical, .su32)
                TextField(text: $viewModel.username)
                    .regularTextFieldStyle(label: "Username")
                    .padding(.bottom, .su16)
                Button("Reset") {
                    viewModel.reset()
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
            }
            .floatingRoundedCardBackground()
            .padding(.vertical, .su16)
            .padding(.horizontal, .su8)
        }
        .toastMessage(toastMessage: $viewModel.toast)
        .headerView(title: "Welcome to PowderTrackr", description: "Password Reset")
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
