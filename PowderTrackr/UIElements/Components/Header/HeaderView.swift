import SwiftUI

struct HeaderView: View {
    let title: String
    let description: String?
    let backAction: (() -> Void)?
    let bottomView: AnyView?
    
    var body: some View {
        VStack(alignment: .center, spacing: .su16) {
            HStack(spacing: .su16) {
                if let action = backAction {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.fill")
                            .resizable()
                            .frame(width: .su20, height: .su20)
                            .foregroundColor(.white)
                    }
                } else {
                    Spacer()
                }
                Text(title)
                    .textStyle(.h4)
                Spacer()
            }
            if let description = description {
                Text(description)
                    .font(.title3)
                    .bold()
            }
            if let bottomView = bottomView {
                bottomView
                    .padding(.bottom, .su8)
            }
        }
        .foregroundColor(.white)
        .padding(.su16)
        .background(Color.bluePrimary)
        .cornerRadius(.su16, corners: [.bottomLeft, .bottomRight])
        .background(
            GeometryReader { geo in
                Color.bluePrimary
                    .frame(height: geo.safeAreaInsets.top + .su16)
                    .edgesIgnoringSafeArea(.top)
                    .offset(y: -geo.size.height)
            }
        )
        .customShadow(style: .dark)
    }
    
    init(
        title: String,
        description: String?,
        backAction: (() -> Void)?,
        bottomView: AnyView?
    ) {
        self.title = title
        self.description = description
        self.backAction = backAction
        self.bottomView = bottomView
    }
}

#Preview {
    HeaderView(
        title: "Welcome to PowderTrackr",
        description: "Login",
        backAction: nil,
        bottomView: nil
    )
}
