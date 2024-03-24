import SwiftUI

struct VerifyView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
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
            .floatingRoundedCardBackground()
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
        }
        
        .headerView(title: "Welcome to PowderTrackr", description: "Verification")
        .background(Color.grayPrimary)
        .navigationBarBackButtonHidden(true)
    }
}
