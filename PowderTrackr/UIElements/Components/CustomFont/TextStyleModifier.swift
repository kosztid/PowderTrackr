import SwiftUI
import UIKit

public enum TextStyle {
    case h1
    case h1Small
    case h2
    case h2Small
    case h3
    case h3Small
    case h4
    case h5
    case body
    case bodyBold
    case bodySmall
    case bodySmallBold
    case bodyLarge
    case bodyLargeLight
    case bodyLargeBold
    case hugeBold
    case numeralsL
    case numeralsM
    case numeralsS

    var builtInType: Font.TextStyle {
        switch self {
        case .h1: return .largeTitle
        case .h1Small: return .largeTitle
        case .h2Small: return .title
        case .h2: return .title
        case .h3: return .title2
        case .h3Small: return .title2
        case .h4: return .title3
        case .h5: return .headline
        case .body: return .body
        case .bodyBold: return .body
        case .bodySmall: return .caption
        case .bodySmallBold: return .caption
        case .bodyLarge: return .subheadline
        case .bodyLargeLight: return .subheadline
        case .bodyLargeBold: return .subheadline
        case .hugeBold: return .largeTitle
        case .numeralsL: return .largeTitle
        case .numeralsM: return .largeTitle
        case .numeralsS: return .largeTitle
        }
    }
}

public struct TextStyleModifier: ViewModifier {
    @Environment(\.customFontProvider) var customFontProvider

    let textStyle: TextStyle

    public init(textStyle: TextStyle) {
        self.textStyle = textStyle
    }

    public func body(content: Content) -> some View {
        /// https://developer.apple.com/forums/thread/655780
        /// https://stackoverflow.com/a/64652348/5202549
        let uiFont = customFontProvider.font(forUIKitTextStyle: textStyle)
        let customLineHeight = customFontProvider.lineHeight(forTextStyle: textStyle)
        let scale = UIApplication.shared.currentWindow?.screen.scale ?? 2
        let roundedLineHeight = Double(uiFont.lineHeight).roundUp(to: 1 / Double(scale))
        if #available(iOS 16.0, *) {
            return content
                .font(Font(uiFont as CTFont).leading(.tight))
                .lineSpacing(customLineHeight - uiFont.lineHeight)
                .tracking(uiFont.pointSize * 0.0012)
                .padding(.vertical, (customLineHeight - roundedLineHeight) / 2)
        } else {
            return content
                .font(Font(uiFont as CTFont).leading(.tight))
                .lineSpacing(customLineHeight - uiFont.lineHeight)
                .padding(.vertical, (customLineHeight - roundedLineHeight) / 2)
        }
    }
}

public extension Text {
    /// Sets the text style of the scaled custom font for text in the view.
    /// - Parameter textStyle: A dynamic type text styles
    /// - Returns: A View that uses the scaled font with the specified dynamic type text style.
    func textStyle(_ textStyle: TextStyle) -> ModifiedContent<Self, TextStyleModifier> {
        modifier(TextStyleModifier(textStyle: textStyle))
    }
}

public extension HStack {
    /// Sets the text style of the scaled custom font for text in the view.
    /// - Parameter textStyle: A dynamic type text styles
    /// - Returns: A View that uses the scaled font with the specified dynamic type text style.
    func textStyle(_ textStyle: TextStyle) -> ModifiedContent<Self, TextStyleModifier> {
        modifier(TextStyleModifier(textStyle: textStyle))
    }
}

public extension ButtonStyleConfiguration.Label {
    /// Sets the text style of the scaled custom font for text in the view.
    /// - Parameter textStyle: A dynamic type text styles
    /// - Returns: A View that uses the scaled font with the specified dynamic type text style.
    func textStyle(_ textStyle: TextStyle) -> ModifiedContent<Self, TextStyleModifier> {
        modifier(TextStyleModifier(textStyle: textStyle))
    }
}
