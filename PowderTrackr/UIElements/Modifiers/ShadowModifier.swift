import SwiftUI

public struct ShadowModifier: ViewModifier {
    public enum Style {
        case light
        case normal
        case dark
    }
    
    let style: Style
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: .warmGray.opacity(opacity),
                radius: radius,
                x: .zero,
                y: radius
            )
    }
    
    var radius: CGFloat {
        switch style {
        case .light:
            return 4
        case .normal, .dark:
            return 8
        }
    }
    var opacity: Double {
        switch style {
        case .light:
            return 0.1
        case .normal:
            return 0.5
        case .dark:
            return 0.8
        }
    }
    
    public init(style: ShadowModifier.Style = .normal) {
        self.style = style
    }
}

public extension View {
    func customShadow(style: ShadowModifier.Style = .normal) -> some View {
        modifier(
            ShadowModifier(style: .normal)
        )
    }
}
