import SwiftUI

struct VerifyView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                Text("Please verify your email address by entering the verification code from the confirmation email.")
                    .textStyle(.body)
                    .foregroundColor(.gray)
                    .padding(.vertical, .su32)
                TextField(text: $viewModel.verificationCode)
                    .regularTextFieldStyle(label: "Verification Code")
                    .padding(.bottom, .su16)
                TextField(text: $viewModel.username)
                    .regularTextFieldStyle(label: "Username")
                    .padding(.bottom, .su16)
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
        
        .headerView(title: "Welcome to PowderTrackr", description: "Verification")
        .background(Color.grayPrimary)
        .navigationBarBackButtonHidden(true)
    }
}
