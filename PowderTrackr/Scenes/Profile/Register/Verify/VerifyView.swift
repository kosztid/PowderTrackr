import SwiftUI

struct VerifyView: View {
    private typealias Str = Rsc.VerifyView

    @StateObject var viewModel: ViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                Text(Str.Verify.description)
                    .textStyle(.body)
                    .foregroundColor(.gray)
                    .padding(.vertical, .su32)
                TextField(text: $viewModel.verificationCode)
                    .regularTextFieldStyle(label: Str.code)
                    .padding(.bottom, .su16)
                Button(Str.Button.verify) {
                    viewModel.verify()
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
            }
            .floatingRoundedCardBackground()
            .padding(.vertical, .su16)
            .padding(.horizontal, .su8)
        }

        .headerView(description: Str.Header.description)
        .background(Color.grayPrimary)
        .navigationBarBackButtonHidden(true)
    }
}
