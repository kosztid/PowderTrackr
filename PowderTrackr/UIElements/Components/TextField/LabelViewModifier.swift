import SwiftUI

private struct LabelViewModifier: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled

    let text: String?

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let text {
                Text(text)
                    .foregroundColor(isEnabled ? .black : .gray)
            }
            content
        }
    }
}

extension View {
    func label(_ text: String?) -> some View {
        modifier(LabelViewModifier(text: text))
    }
}
