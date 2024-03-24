import SwiftUI

struct ResetPasswordView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                Text("Please type in your username to reset your password.")
                    .foregroundColor(.gray)
                    .padding(.vertical, 32)
                TextField(text: $viewModel.username)
                    .regularTextFieldStyle(label: "Username")
                    .padding(.bottom, 16)
                Button(
                    action: {
                        viewModel.reset()
                    },
                    label: {
                        Text("Reset")
                            .font(.title3)
                    }
                )
                .buttonStyle(SkiingButtonStyle(style: .secondary))
            }
            .floatingRoundedCardBackground()
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
        }
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
