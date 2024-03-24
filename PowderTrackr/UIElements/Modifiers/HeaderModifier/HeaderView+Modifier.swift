import SwiftUI

struct HeaderViewModifier: ViewModifier {
    let title: String
    let description: String?
    
    func body(content: Content) -> some View {
        VStack(spacing: .zero) {
            HeaderView(title: title, description: description)
            content
        }
    }
}

extension View {
    func headerView(title: String, description: String? = nil) -> some View {
        self.modifier(HeaderViewModifier(title: title, description: description))
    }
}
