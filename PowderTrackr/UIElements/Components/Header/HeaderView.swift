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
    
    var body: some View {
        ZStack {
            Color.bluePrimary
                .cornerRadius(.su16, corners: [.bottomLeft, .bottomRight])
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: .zero) {
                HStack(spacing: .su16) {
                    if let action = backAction {
                        Button {
                            action()
                        } label: {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                .foregroundColor(.white)
                        }
                        .padding(.leading, .su16)
                    } else {
                        Spacer()
                    }
                    Text(title)
                        .textStyle(.h4)
                        .padding(.bottom, style == .normal ? .su16 : .zero)
                    Spacer()
                }
                if let description = description {
                    Text(description)
                        .font(.title3)
                        .bold()
                }
            }
            .foregroundColor(.white)
        }
        .frame(height: headerHeight)
        .customShadow(style: .dark)
    }
    
    init(
        title: String,
        style: Style = .normal,
        description: String?,
        backAction: (() -> Void)?
    ) {
        self.style = style
        self.title = title
        self.description = description
        self.backAction = backAction
    }
}

extension HeaderView {
    var headerHeight: CGFloat {
        switch style {
        case .inline:
            60
        case .normal:
            160
        }
    }
}

#Preview {
    HeaderView(
        title: "Welcome to PowderTrackr",
        style: .normal,
        description: "Login",
        backAction: nil
    )
}
