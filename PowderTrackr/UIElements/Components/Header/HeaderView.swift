import SwiftUI

struct HeaderView: View {
    enum Style {
        case inline
        case normal
    }
    
    let style: Style
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
        .frame(height: headerHeight)
        .customShadow(style: .dark)
    }
    
    init(
        title: String,
        style: Style = .normal,
        description: String?
    ) {
        self.style = style
        self.title = title
        self.description = description
    }
}

extension HeaderView {
    var headerHeight: CGFloat {
        switch style {
        case .inline:
            40
        case .normal:
            160
        }
    }
}

#Preview {
    HeaderView(title: "Welcome to PowderTrackr", style: .normal, description: "Login")
}
