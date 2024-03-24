import SwiftUI

struct ChangePasswordView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
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
            .floatingRoundedCardBackground()
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
        }
        
        .headerView(title: "Welcome to PowderTrackr", description: "Update Password")
        .background(Color.grayPrimary)
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
