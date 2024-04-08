import SwiftUI

struct ChangePasswordView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                Text("Please type in your old and new password to change it.")
                    .textStyle(.body)
                    .foregroundColor(.gray)
                    .padding(.vertical, .su32)
                ToggleableSecureField(text: $viewModel.oldPassword)
                    .regularTextFieldStyle(label: "Old Password")
                    .padding(.bottom, .su8)
                ToggleableSecureField(text: $viewModel.newPassword)
                    .regularTextFieldStyle(label: "New Password")
                    .padding(.bottom, .su16)
                Button("Update") {
                    viewModel.changeButtonTap()
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
            }
            .floatingRoundedCardBackground()
            .padding(.vertical, .su16)
            .padding(.horizontal, .su8)
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
