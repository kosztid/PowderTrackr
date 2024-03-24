import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                Text("Please fill the fields to create an account")
                    .foregroundColor(.blueSecondary)
                    .padding(.top, 16)
                TextField(text: $viewModel.userName)
                    .regularTextFieldStyle(label: "Username")
                TextField(text: $viewModel.email)
                    .regularTextFieldStyle(label: "Email")
                ToggleableSecureField(text: $viewModel.password)
                    .regularTextFieldStyle(label: "Password")
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
            .floatingRoundedCardBackground()
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
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
