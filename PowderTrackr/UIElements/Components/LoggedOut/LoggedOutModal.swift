import SwiftUI

struct LoggedOutModal: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Text("Please log in to continue")
                        .bold()
                        .padding(.vertical, 100)
                        .padding(.horizontal, 40)
                        .background(Color.teal)
                        .foregroundColor(Color.white)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                Spacer()
            }
        }
    }
}

struct LoggedOutModal_Previews: PreviewProvider {
    static var previews: some View {
        LoggedOutModal()
    }
}
