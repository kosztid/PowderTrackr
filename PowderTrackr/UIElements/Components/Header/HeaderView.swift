import SwiftUI

struct HeaderView: View {
    enum Style {
        case inline
        case normal
    }
    
    let style: Style
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
        style: Style = .normal,
        description: String?,
        backAction: (() -> Void)?,
        bottomView: AnyView?
    ) {
        self.style = style
        self.title = title
        self.description = description
        self.backAction = backAction
        self.bottomView = bottomView
    }
}

extension HeaderView {
    var headerHeight: CGFloat {
        switch style {
        case .inline:
            80
        case .normal:
            128
        }
    }
}

#Preview {
    HeaderView(
        title: "Welcome to PowderTrackr",
        style: .normal,
        description: "Login",
        backAction: nil,
        bottomView: nil
    )
}
