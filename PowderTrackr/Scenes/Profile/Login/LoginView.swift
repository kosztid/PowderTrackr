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
        VStack(spacing: 16) {
            Text("Please enter your credentials")
                .foregroundColor(.blueSecondary)
                .padding(.top, 16)
            TextField(text: $viewModel.userName)
                .regularTextFieldStyle(label: "Username")
            ToggleableSecureField(text: $viewModel.password)
                .regularTextFieldStyle(label: "Password")
            HStack {
                Button {
                    viewModel.resetPassword()
                } label: {
                    Text("Forgotten Password")
                        .font(.caption)
                }
                .padding(.leading, 12)
                Spacer()
            }
            errorBanner
            Button(
                action: {
                    viewModel.login()
                },
                label: {
                    Text("Login")
                        .font(.title3)
                }
            )
            .buttonStyle(SkiingButtonStyle(style: .secondary))
        }
        .floatingRoundedCardBackground()
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
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
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    ViewFactory.profileView(navigator: ProfileNavigator(dismissNavigator: {}))
}
