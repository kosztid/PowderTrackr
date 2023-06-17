import SwiftUI

private struct TextFieldBorderViewModifier: ViewModifier {

    private var strokeBorderColor: Color {
        .black
    }

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(strokeBorderColor, lineWidth: 2)
            )
    }
}

extension View {
    func textFieldBorder() -> some View {
        modifier(TextFieldBorderViewModifier())
    }
}
