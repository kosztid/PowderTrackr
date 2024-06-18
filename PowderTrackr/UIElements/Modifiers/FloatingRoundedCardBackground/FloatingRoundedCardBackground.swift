import SwiftUI

struct FloatingRoundedCardBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.su16)
            .background(Color.softWhite)
            .cornerRadius(.su12)
            .customShadow(style: .light)
            .padding(.horizontal, .su8)
    }
}

extension View {
    func floatingRoundedCardBackground() -> some View {
        self.modifier(FloatingRoundedCardBackgroundModifier())
    }
}
