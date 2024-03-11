import SwiftUI

struct LoggedOutModal: View {
    let action: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Text("To access this page you have to log in")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 32)
                Text("Tap to Log in")
                    .font(.title3)
                    .bold()
            }
            .padding(.vertical, 80)
            .padding(.horizontal, 32)
            .background(Color.teal)
            .foregroundColor(Color.white)
            .cornerRadius(16)
            .padding(32)
            .onTapGesture {
                action()
            }
        }
    }
}

struct LoggedOutModal_Previews: PreviewProvider {
    static var previews: some View {
        LoggedOutModal(action: {})
    }
}
