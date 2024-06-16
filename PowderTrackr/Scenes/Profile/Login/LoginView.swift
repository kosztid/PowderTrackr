import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            loginCredentials
        }
        .headerView(title: "Welcome to PowderTrackr", description: "Login")
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
            Text("Please enter your credentials")
                .textStyle(.body)
                .foregroundColor(.blueSecondary)
                .padding(.top, .su16)
            TextField(text: $viewModel.userName)
                .regularTextFieldStyle(label: "Username")
            ToggleableSecureField(text: $viewModel.password)
                .regularTextFieldStyle(label: "Password")
            HStack {
                Button {
                    viewModel.resetPassword()
                } label: {
                    Text("Forgotten Password")
                        .textStyle(.bodySmall)
                }
                .padding(.leading, .su12)
                Spacer()
            }
            errorBanner
            Button("Login") {
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
                Text("Failed to log in please check your credentials")
                    .foregroundStyle(.red)
                    .font(.subheadline)
                Text("Please check your credentials")
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
