import SwiftUI

struct VerifyView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: .zero) {
            ZStack {
                Color.teal
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
            .frame(height: 200)
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text("Please verify your email address by entering the verification code from the confirmation email.")
                        .foregroundColor(.gray)
                        .padding(.vertical, 32)
                    TextField(text: $viewModel.verificationCode)
                        .regularTextFieldStyle(label: "Verification Code")
                        .padding(.bottom, 16)
                    TextField(text: $viewModel.username)
                        .regularTextFieldStyle(label: "Username")
                        .padding(.bottom, 16)
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
                .padding(.horizontal, 32)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
