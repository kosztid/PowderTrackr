import SwiftUI

struct RegisterView: View {
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
                    Text("Registration")
                        .font(.title3)
                        .bold()
                }
                .foregroundColor(.white)
            }
            .frame(height: 200)
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text("Please fill the fields to create an account")
                        .foregroundColor(.gray)
                        .padding(.vertical, 32)
                    TextField(text: $viewModel.userName)
                        .regularTextFieldStyle(label: "Username")
                        .padding(.bottom, 16)
                    TextField(text: $viewModel.email)
                        .regularTextFieldStyle(label: "Email")
                        .padding(.bottom, 16)
                    ToggleableSecureField(text: $viewModel.password)
                        .regularTextFieldStyle(label: "Password")
                        .padding(.bottom, 8)
                    Button(
                        action: {
                            viewModel.register()
                        },
                        label: {
                            Text("Register")
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
