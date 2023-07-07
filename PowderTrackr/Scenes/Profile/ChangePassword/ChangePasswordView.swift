import SwiftUI

struct ChangePasswordView: View {
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
                    Text("Update Password")
                        .font(.title3)
                        .bold()
                }
                .foregroundColor(.white)
            }
            .frame(height: 200)
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text("Please type in your old and new password to change it.")
                        .foregroundColor(.gray)
                        .padding(.vertical, 32)
                    ToggleableSecureField(text: $viewModel.oldPassword)
                        .regularTextFieldStyle(label: "Old Password")
                        .padding(.bottom, 8)
                    ToggleableSecureField(text: $viewModel.newPassword)
                        .regularTextFieldStyle(label: "New Password")
                        .padding(.bottom, 16)
                    Button(
                        action: {
                            viewModel.changeButtonTap()
                        },
                        label: {
                            Text("Update")
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
