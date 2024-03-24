import SwiftUI

struct FloatingRoundedCardBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color.softWhite)
            .cornerRadius(12)
            .customShadow(style: .light)
            .padding(.horizontal, 8)
    }
}

extension View {
    func floatingRoundedCardBackground() -> some View {
        self.modifier(FloatingRoundedCardBackgroundModifier())
    }
}
