import SwiftUI

struct ChangePasswordView: View {
    private typealias Str = Rsc.ChangePasswordView
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                Text(Str.Password.description)
                    .textStyle(.body)
                    .foregroundColor(.gray)
                    .padding(.vertical, .su32)
                ToggleableSecureField(text: $viewModel.oldPassword)
                    .regularTextFieldStyle(label: Str.Password.old)
                    .padding(.bottom, .su8)
                ToggleableSecureField(text: $viewModel.newPassword)
                    .regularTextFieldStyle(label: Str.Password.new)
                    .padding(.bottom, .su16)
                Button(Str.Button.update) {
                    viewModel.changeButtonTap()
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
