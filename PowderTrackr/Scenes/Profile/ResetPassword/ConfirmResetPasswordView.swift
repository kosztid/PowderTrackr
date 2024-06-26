import SwiftUI

struct ConfirmResetPasswordView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text("Please enter the verification code from the password reset email to reset password for user: \(viewModel.username)")
                        .textStyle(.body)
                        .foregroundColor(.gray)
                        .padding(.vertical, .su32)
                    TextField(text: $viewModel.verificationCode)
                        .regularTextFieldStyle(label: "Verification Code")
                        .padding(.bottom, .su16)
                    TextField(text: $viewModel.username)
                        .regularTextFieldStyle(label: "Username")
                        .padding(.bottom, .su16)
                        .disabled(true)
                    ToggleableSecureField(text: $viewModel.password)
                        .regularTextFieldStyle(label: "Password")
                        .padding(.bottom, .su16)
                    Button("Verify") {
                        viewModel.verify()
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                }
                .floatingRoundedCardBackground()
                .padding(.vertical, .su16)
                .padding(.horizontal, .su8)
            }
            .toastMessage(toastMessage: $viewModel.toast)
            .headerView(title: "Welcome to PowderTrackr", description: "Verification")
            .navigationBarBackButtonHidden(true)
    }
}
