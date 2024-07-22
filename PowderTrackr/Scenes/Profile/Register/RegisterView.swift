import SwiftUI

struct RegisterView: View {
    private typealias Str = Rsc.RegisterView

    @StateObject var viewModel: ViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .su16) {
                Text(Str.Register.description)
                    .textStyle(.body)
                    .foregroundColor(.blueSecondary)
                    .padding(.top, .su16)
                TextField(text: $viewModel.username)
                    .regularTextFieldStyle(label: Str.username)
                TextField(text: $viewModel.email)
                    .regularTextFieldStyle(label: Str.email)
                ToggleableSecureField(text: $viewModel.password)
                    .regularTextFieldStyle(label: Str.password)
                Button(Str.Button.register) {
                    viewModel.register()
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
            }
            .floatingRoundedCardBackground()
            .padding(.vertical, .su16)
            .padding(.horizontal, .su8)
        }
        .headerView(description: Str.Header.description)
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
