import SwiftUI

struct LoggedOutModal: View {
    private enum Layout {
        static let backgroundOpacity: CGFloat = 0.3
    }

    let action: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(Layout.backgroundOpacity)
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Text("To access this page you have to log in")
                    .textStyle(.bodyLargeBold)
                    .padding(.bottom, .su32)
                Text("Tap to Log in")
                    .font(.title3)
                    .bold()
            }
            .padding(.vertical, .su80)
            .padding(.horizontal, .su32)
            .background(Color.cyanSecondary)
            .foregroundColor(Color.softWhite)
            .cornerRadius(.su16)
            .padding(.su32)
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
