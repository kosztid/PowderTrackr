import SwiftUI

public struct SkiingButtonStyle: ButtonStyle {
    private enum Layout {
        static let paddingWidth: CGFloat = 24
        static let compactPaddingWidth: CGFloat = 12
        static let frameHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 20
        static let stroke: CGFloat = 1
    }

    public enum Style {
        case primary
        case secondary
        case secondaryCompact
        case bordered
        case borderedRed
        case imageBordered(Image)

        var foregroundColor: Color {
            switch self {
            case .primary: return Color.softWhite
            case .secondary, .secondaryCompact: return Color.softWhite
            case .bordered: return Color.blueSecondary
            case .borderedRed: return Color.redUtility
            case .imageBordered: return Color.black
            }
        }

        var background: Color {
            switch self {
            case .primary: return Color.blueSecondary
            case .secondary, .secondaryCompact: return Color.cyanSecondary
            case .bordered: return Color.black
            case .borderedRed: return Color.black
            case .imageBordered: return Color.black
            }
        }

        var disabledBackground: Color {
            Color.grayPrimary
        }

        var disabledForeground: Color {
            Color.softWhite
        }
    }

    @Environment(\.isEnabled) var isEnabled

    private let style: Style

    public init(style: Style = .primary) {
        self.style = style
    }

    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        switch style {
        case .primary, .secondary:
            plainStyle(configuration)
        case .secondaryCompact:
            plainCompactStyle(configuration)
        case .bordered:
            borderedStyle(configuration)
        case .borderedRed:
            borderedStyle(configuration)
        case .imageBordered(let image):
            imageBorderedStyle(configuration, image: image)
        }
    }

    @ViewBuilder
    private func plainStyle(_ configuration: ButtonStyle.Configuration) -> some View {
        if isEnabled {
            configuration.label
                .textStyle(.bodyLargeBold)
                .padding([.leading, .trailing], Layout.paddingWidth)
                .frame(minHeight: Layout.frameHeight)
                .foregroundColor(style.foregroundColor)
                .background(style.background)
                .cornerRadius(Layout.cornerRadius)
                .customShadow(style: .light)
        } else {
            configuration.label
                .textStyle(.bodyLargeBold)
                .padding([.leading, .trailing], Layout.paddingWidth)
                .frame(minHeight: Layout.frameHeight)
                .foregroundColor(style.disabledForeground)
                .background(style.disabledBackground)
                .cornerRadius(Layout.cornerRadius)
        }
    }

    @ViewBuilder
    private func plainCompactStyle(_ configuration: ButtonStyle.Configuration) -> some View {
        if isEnabled {
            configuration.label
                .textStyle(.bodyLarge)
                .padding([.leading, .trailing], Layout.compactPaddingWidth)
                .foregroundColor(style.foregroundColor)
                .background(style.background)
                .cornerRadius(Layout.cornerRadius)
        } else {
            configuration.label
                .textStyle(.bodyLarge)
                .padding([.leading, .trailing], Layout.compactPaddingWidth)
                .foregroundColor(style.disabledForeground)
                .background(style.disabledBackground)
                .cornerRadius(Layout.cornerRadius)
        }
    }

    @ViewBuilder
    private func borderedStyle(_ configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .textStyle(.bodyLargeBold)
            .foregroundColor(style.foregroundColor)
            .padding(.vertical, .su10)
            .padding(.horizontal, Layout.paddingWidth)
            .background(Color.softWhite)
            .cornerRadius(Layout.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .stroke(style.foregroundColor, lineWidth: Layout.stroke)
            )
            .customShadow(style: .light)
    }

    @ViewBuilder
    private func imageBorderedStyle(_ configuration: ButtonStyle.Configuration, image: Image) -> some View {
        HStack {
            image
            configuration.label
            Spacer()
        }
        .foregroundColor(style.foregroundColor)
        .padding(.vertical, .su10)
        .padding(.horizontal, .su20)
        .overlay(
            RoundedRectangle(cornerRadius: .su20)
                .stroke(style.foregroundColor, lineWidth: Layout.stroke)
        )
    }
}
