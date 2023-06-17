import SwiftUI

struct LoginView: View {
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
                    Text("Login")
                        .font(.title3)
                        .bold()
                }
                .foregroundColor(.white)
            }
            .frame(height: 200)
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text("Please enter your credentials")
                        .foregroundColor(.gray)
                        .padding(.vertical, 32)
                    TextField(text: $viewModel.userName)
                        .regularTextFieldStyle(label: "UserName")
                        .padding(.bottom, 16)
                    ToggleableSecureField(text: $viewModel.password)
                        .regularTextFieldStyle(label: "Password")
                        .padding(.bottom, 8)
                    HStack {
                        Button {
                        } label: {
                            Text("Forgotten Password")
                                .font(.caption)
                        }
                        .padding(.leading, 12)
                        Spacer()
                    }
                    .padding(.bottom, 16)
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
        .navigationBarBackButtonHidden(true)
    }
}
