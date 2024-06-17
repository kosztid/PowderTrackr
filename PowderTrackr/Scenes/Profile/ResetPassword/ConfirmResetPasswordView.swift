import SwiftUI

struct ConfirmResetPasswordView: View {
    private typealias Str = Rsc.ConfirmResetPasswordView
    
    @StateObject var viewModel: ViewModel

    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text(Str.Username.description((viewModel.username)))
                        .textStyle(.body)
                        .foregroundColor(.gray)
                        .padding(.vertical, .su32)
                    TextField(text: $viewModel.verificationCode)
                        .regularTextFieldStyle(label: Str.code)
                        .padding(.bottom, .su16)
                    TextField(text: $viewModel.username)
                        .regularTextFieldStyle(label: Str.username)
                        .padding(.bottom, .su16)
                        .disabled(true)
                    ToggleableSecureField(text: $viewModel.password)
                        .regularTextFieldStyle(label: Str.password)
                        .padding(.bottom, .su16)
                    Button(Str.Button.verify) {
                        viewModel.verify()
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                }
                .floatingRoundedCardBackground()
                .padding(.vertical, .su16)
                .padding(.horizontal, .su8)
            }
            .toastMessage(toastMessage: $viewModel.toast)
            .headerView(description: Str.Header.description)
            .navigationBarBackButtonHidden(true)
    }
}
