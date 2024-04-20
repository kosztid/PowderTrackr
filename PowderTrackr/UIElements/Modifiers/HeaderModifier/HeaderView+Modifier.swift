import SwiftUI

struct HeaderViewModifier: ViewModifier {
    let title: String
    let description: String?
    let style: HeaderView.Style
    
    func body(content: Content) -> some View {
        VStack(spacing: .zero) {
            HeaderView(title: title, style: style, description: description)
            content
        }
    }
}

extension View {
    func headerView(title: String, style: HeaderView.Style = .normal, description: String? = nil) -> some View {
        self.modifier(HeaderViewModifier(title: title, description: description, style: style))
    }
}
