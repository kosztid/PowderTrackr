import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .su16) {
                Text("Please fill the fields to create an account")
                    .textStyle(.body)
                    .foregroundColor(.blueSecondary)
                    .padding(.top, .su16)
                TextField(text: $viewModel.userName)
                    .regularTextFieldStyle(label: "Username")
                TextField(text: $viewModel.email)
                    .regularTextFieldStyle(label: "Email")
                ToggleableSecureField(text: $viewModel.password)
                    .regularTextFieldStyle(label: "Password")
                Button("Register") {
                    viewModel.register()
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
            }
            .floatingRoundedCardBackground()
            .padding(.vertical, .su16)
            .padding(.horizontal, .su8)
        }
        .headerView(title: "Welcome to PowderTrackr", description: "Register")
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
}
