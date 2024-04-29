import SwiftUI

public struct CustomFontProvider {
    public init() {}

    public func font(forUIKitTextStyle textStyle: TextStyle, fixedSize: CGFloat? = nil) -> UIFont {
        if let fixedSize {
            return UIFont(name: fontName(for: textStyle), size: fixedSize)
            ?? UIFont.preferredFont(forTextStyle: .init(from: textStyle.builtInType)).withSize(fixedSize)
        } else {
            guard let font = UIFont(name: fontName(for: textStyle), size: fontSize(for: textStyle)) else {
                return UIFont.preferredFont(forTextStyle: .init(from: textStyle.builtInType))
            }

            return UIFontMetrics(forTextStyle: .init(from: textStyle.builtInType)).scaledFont(for: font)
        }
    }

    public func font(textStyle: TextStyle) -> Font {
        Font(font(forUIKitTextStyle: textStyle) as CTFont).leading(.tight)
    }

    public func lineHeight(forTextStyle textStyle: TextStyle) -> Double {
        let font = font(forUIKitTextStyle: textStyle)
        return lineHeight(for: textStyle, from: font.pointSize)
    }

    private func lineHeight(for textStyle: TextStyle, from fontSize: Double) -> Double {
        (fontSize * lineHeightMultiplier(for: textStyle)).roundUp(to: 4)
    }

    private func lineHeightMultiplier(for textStyle: TextStyle) -> Double {
        switch textStyle {
        case .h1: return 1.25
        case .h1Small: return 1.25
        case .h2: return 1.25
        case .h2Small: return 1.25
        case .h3: return 1.25
        case .h3Small: return 1.25
        case .h4: return 1.25
        case .h5: return 1.25
        case .body: return 1.5
        case .bodyBold: return 1.5
        case .bodySmall: return 1.5
        case .bodySmallBold: return 1.5
        case .bodyLarge: return 1.25
        case .bodyLargeLight: return 1.25
        case .bodyLargeBold: return 1.25
        case .hugeBold: return 1.0
        case .numeralsL: return 1.0
        case .numeralsM: return 1.0
        case .numeralsS: return 1.0
        }
    }

    private func fontName(for textStyle: TextStyle) -> String {
        switch textStyle {
        case .h1: return UIFont.heavyFontName
        case .h1Small: return UIFont.heavyFontName
        case .h2: return UIFont.heavyFontName
        case .h2Small: return UIFont.heavyFontName
        case .h3: return UIFont.heavyFontName
        case .h3Small: return UIFont.heavyFontName
        case .h4: return UIFont.heavyFontName
        case .h5: return UIFont.heavyFontName
        case .body: return UIFont.regularFontName
        case .bodyBold: return UIFont.boldFontName
        case .bodySmall: return UIFont.regularFontName
        case .bodySmallBold: return UIFont.boldFontName
        case .bodyLarge: return UIFont.regularFontName
        case .bodyLargeLight: return UIFont.lightFontName
        case .bodyLargeBold: return UIFont.boldFontName
        case .hugeBold: return UIFont.boldFontName
        case .numeralsL: return UIFont.heavyFontName
        case .numeralsM: return UIFont.heavyFontName
        case .numeralsS: return UIFont.heavyFontName
        }
    }

    private func fontSize(for textStyle: TextStyle) -> Double {
        switch textStyle {
        case .h1: return 39.8
        case .h1Small: return 28.8
        case .h2: return 33.2
        case .h2Small: return 22.8
        case .h3: return 27.7
        case .h3Small: return 18
        case .h4: return 23
        case .h5: return 19.2
        case .body: return 16
        case .bodyBold: return 16
        case .bodySmall: return 14
        case .bodySmallBold: return 14
        case .bodyLarge: return 19.2
        case .bodyLargeLight: return 19.2
        case .bodyLargeBold: return 19.2
        case .hugeBold: return 110
        case .numeralsL: return 54
        case .numeralsM: return 36
        case .numeralsS: return 28
        }
    }
}

private extension UIFont.TextStyle {
    init(from textStyle: Font.TextStyle) {
        switch textStyle {
        case .largeTitle: self = .largeTitle
        case .title: self = .title1
        case .title2: self = .title2
        case .title3: self = .title3
        case .headline: self = .headline
        case .subheadline: self = .subheadline
        case .body: self = .body
        case .callout: self = .callout
        case .footnote: self = .footnote
        case .caption: self = .caption1
        case .caption2: self = .caption2
        default: self = .body
        }
    }
}
