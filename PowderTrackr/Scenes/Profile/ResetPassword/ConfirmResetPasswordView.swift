import SwiftUI

struct ConfirmResetPasswordView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: .zero) {
            ZStack {
                Color.bluePrimary
                    .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                    .ignoresSafeArea()
                VStack(spacing: .zero) {
                    Text("Welcome to Skiing")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 16)
                    Text("Verification")
                        .font(.title3)
                        .bold()
                }
                .foregroundColor(.white)
            }
            .frame(height: 160)
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text("Please enter the verification code from the password reset email to reset password for user: \(viewModel.username)")
                        .foregroundColor(.gray)
                        .padding(.vertical, 32)
                    TextField(text: $viewModel.verificationCode)
                        .regularTextFieldStyle(label: "Verification Code")
                        .padding(.bottom, 16)
                    TextField(text: $viewModel.username)
                        .regularTextFieldStyle(label: "Username")
                        .padding(.bottom, 16)
                        .disabled(true)
                    ToggleableSecureField(text: $viewModel.password)
                        .regularTextFieldStyle(label: "Password")
                        .padding(.bottom, 16)
                    Button(
                        action: {
                            viewModel.verify()
                        },
                        label: {
                            Text("Verify")
                                .font(.title3)
                        }
                    )
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                }
                .floatingRoundedCardBackground()
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
