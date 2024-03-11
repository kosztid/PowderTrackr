import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: .zero) {
            ZStack {
                Color.teal
                    .ignoresSafeArea()
                VStack(alignment: .center, spacing: .zero) {
                    Text("Welcome to PowderTrackr")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 16)
                    Text("Login")
                        .font(.title3)
                        .bold()
                }
                .foregroundColor(.white)
            }
            .frame(height: 160)
            .customShadow()
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text("Please enter your credentials")
                        .foregroundColor(.gray)
                        .padding(.vertical, 32)
                    TextField(text: $viewModel.userName)
                        .regularTextFieldStyle(label: "Username")
                        .padding(.bottom, 16)
                    ToggleableSecureField(text: $viewModel.password)
                        .regularTextFieldStyle(label: "Password")
                        .padding(.bottom, 8)
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
                    .padding(.bottom, 16)
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
                .padding(.horizontal, 32)
            }
        }
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
