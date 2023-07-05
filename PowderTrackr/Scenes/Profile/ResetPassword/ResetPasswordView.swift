import SwiftUI

struct ResetPasswordView: View {
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
                    Text("Password Reset")
                        .font(.title3)
                        .bold()
                }
                .foregroundColor(.white)
            }
            .frame(height: 200)
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text("Please type in your username to reset your password.")
                        .foregroundColor(.gray)
                        .padding(.vertical, 32)
                    TextField(text: $viewModel.username)
                        .regularTextFieldStyle(label: "Username")
                        .padding(.bottom, 16)
                    Button(
                        action: {
                            viewModel.reset()
                        },
                        label: {
                            Text("Reset")
                                .font(.title3)
                        }
                    )
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                }
                .padding(.horizontal, 32)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.navigateBack()
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
