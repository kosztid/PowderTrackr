import SwiftUI

struct HeaderView: View {
    let title: String
    let description: String?
    
    var body: some View {
        ZStack {
            Color.bluePrimary
                .cornerRadius(.su16, corners: [.bottomLeft, .bottomRight])
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: .zero) {
                Text(title)
                    .textStyle(.h4)
                    .padding(.bottom, .su16)
                if let description = description {
                    Text(description)
                        .font(.title3)
                        .bold()
                }
            }
            .foregroundColor(.white)
        }
        .frame(height: 160)
        .customShadow(style: .dark)
    }
}

#Preview {
    HeaderView(title: "Welcome to PowderTrackr", description: "Login")
}
