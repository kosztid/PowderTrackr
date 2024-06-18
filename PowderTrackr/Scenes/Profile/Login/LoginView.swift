import SwiftUI

struct LoginView: View {
    private typealias Str = Rsc.LoginView

    @StateObject var viewModel: ViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            loginCredentials
        }
        .headerView(description: Str.Header.description)
        .background(Color.grayPrimary)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.dismiss()
                } label: {
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    var loginCredentials: some View {
        VStack(spacing: .su16) {
            Text(Str.Login.description)
                .textStyle(.body)
                .foregroundColor(.blueSecondary)
                .padding(.top, .su16)
            TextField(text: $viewModel.userName)
                .regularTextFieldStyle(label: Str.username)
            ToggleableSecureField(text: $viewModel.password)
                .regularTextFieldStyle(label: Str.password)
            HStack {
                Button {
                    viewModel.resetPassword()
                } label: {
                    Text(Str.Button.forgottenPassword)
                        .textStyle(.bodySmall)
                }
                .padding(.leading, .su12)
                Spacer()
            }
            errorBanner
            Button(Str.Button.login) {
                viewModel.login()
            }
            .buttonStyle(SkiingButtonStyle(style: .secondary))
        }
        .floatingRoundedCardBackground()
        .padding(.vertical, .su16)
        .padding(.horizontal, .su8)
    }

    @ViewBuilder var errorBanner: some View {
        if viewModel.showLoginError {
            VStack(alignment: .center) {
                Text(Str.Error.description)
                    .foregroundStyle(.red)
                    .font(.subheadline)
                Text(Str.Error.subDescription)
                    .foregroundStyle(.red)
                    .font(.subheadline)
            }
            .padding(.bottom, .su16)
        }
    }
}

#Preview {
    ViewFactory.profileView(navigator: ProfileNavigator(dismissNavigator: {}))
}
