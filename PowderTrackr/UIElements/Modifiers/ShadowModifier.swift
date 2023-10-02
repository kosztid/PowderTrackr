import SwiftUI

public struct ShadowModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: .gray.opacity(0.3),
                radius: 4,
                x: .zero,
                y: 4
            )
    }
}

public extension View {
    func customShadow() -> some View {
        modifier(
            ShadowModifier()
        )
    }
}
