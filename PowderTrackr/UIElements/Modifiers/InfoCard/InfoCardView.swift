import SwiftUI

public struct InfoCardView: View {
    public struct Model {
        let message: String
        let subMessage: String?
        let bottomActionButton: InlineButton?
        let trailingButton: ButtonModel?

        public struct ButtonModel: Equatable {
            let image: Image
            let action: () -> Void

            public init(
                image: Image,
                action: @escaping () -> Void
            ) {
                self.image = image
                self.action = action
            }

            public static func == (lhs: Self, rhs: Self) -> Bool {
                lhs.image == rhs.image
            }
        }

        public struct InlineButton: Equatable {
            let title: String
            let action: () -> Void

            public init(
                title: String,
                action: @escaping () -> Void
            ) {
                self.title = title
                    self.action = action
            }

            public static func == (lhs: Self, rhs: Self) -> Bool {
                lhs.title == rhs.title
            }
        }

        public init(
            message: String,
            subMessage: String? = nil,
            bottomActionButton: InlineButton? = nil,
            trailingButton: ButtonModel? = nil
        ) {
            self.message = message
            self.subMessage = subMessage
            self.bottomActionButton = bottomActionButton
            self.trailingButton = trailingButton
        }
    }

    public enum Style {
        case error
        case errorWithoutIcon
        case info
        case successWithoutIcon
        case success
        case warning

        var icon: Image? {
            switch self {
            case .error:
                return Image(systemName: "exclamationmark.triangle")
            case .info, .warning, .successWithoutIcon, .errorWithoutIcon:
                return nil
            case .success:
                return Image(systemName: "checkmark")
            }
        }

        var backgroundColor: Color {
            switch self {
            case .error, .errorWithoutIcon:
                return .errorSecondary
            case .info:
                return .blueSecondary
            case .success, .successWithoutIcon:
                return .grayPrimary
            case .warning:
                return .warningPrimary
            }
        }

        var textBackgroundColor: Color {
            switch self {
            case .error, .errorWithoutIcon:
                return .errorPrimary
            case .info:
                return .bluePrimary
            case .success, .successWithoutIcon:
                return .darkSlateGray
            case .warning:
                return .warningSecondary
            }
        }
    }

    let message: String
    let subMessage: String?
    let bottomButton: Model.InlineButton?
    let style: Style
    let trailingButton: Model.ButtonModel?

    public var body: some View {
        HStack(alignment: .top, spacing: .zero) {
            VStack {
                if let icon = style.icon {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: style == .success ? .su24 : .su16)
                }
            }
            .padding(.horizontal, .su8)
            .padding(.vertical, .su16)
            .accessibilityHidden(true)
            HStack(alignment: .top, spacing: .zero) {
                VStack(alignment: .leading, spacing: .su16) {
                    VStack(alignment: .leading, spacing: .su4) {
                        Text(message)
                        if let subMessage {
                            Text(subMessage)
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    if let bottomButton {
                        HStack {
                            Spacer()
                            Button {
                                bottomButton.action()
                            } label: {
                                Text(bottomButton.title)
                                    .textStyle(.bodyBold)
                                    .foregroundColor(.darkSlateGray)
                                    .padding(.horizontal, .su24)
                                    .padding(.vertical, .su4)
                                    .background(
                                        RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                                            .strokeBorder(
                                                Color.darkSlateGray, lineWidth: .su2
                                            )
                                    )
                            }
                            .foregroundColor(.darkSlateGray)
                        }
                    }
                }
                .padding(.su16)
                if let trailingButton {
                    Spacer()
                    Button {
                        trailingButton.action()
                    } label: {
                        trailingButton.image
                    }
                    .padding(.su16)
                } else {
                    Spacer()
                }
            }
            .background(style.textBackgroundColor)
        }
        .background(style.backgroundColor)
        .cornerRadius(.su8, corners: .allCorners)
        .fixedSize(horizontal: false, vertical: true)
    }

    public init(model: Model, style: Style) {
        self.message = model.message
        self.subMessage = model.subMessage
        self.trailingButton = model.trailingButton
        self.style = style
        self.bottomButton = model.bottomActionButton
    }
}

extension InfoCardView.Model: Equatable {
    public static func == (lhs: InfoCardView.Model, rhs: InfoCardView.Model) -> Bool {
        lhs.message == rhs.message &&
        lhs.subMessage == rhs.subMessage &&
        lhs.bottomActionButton == rhs.bottomActionButton &&
        lhs.trailingButton == rhs.trailingButton
    }
}
