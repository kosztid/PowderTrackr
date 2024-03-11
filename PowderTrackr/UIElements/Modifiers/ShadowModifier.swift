import SwiftUI

public struct ShadowModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .shadow(
                color: .gray.opacity(0.5),
                radius: 8,
                x: .zero,
                y: 8
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
