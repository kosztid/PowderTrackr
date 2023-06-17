import SwiftUI

private struct BaseTextFieldStyleViewModifier: ViewModifier {
    enum Layout {
        static let height: Double = 48
    }

    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .accentColor(.black)
            .frame(height: Layout.height)
    }
}

extension View {
    func baseTextFieldStyle() -> some View {
        modifier(BaseTextFieldStyleViewModifier())
    }
}
