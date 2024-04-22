import SwiftUI

struct HeaderViewModifier: ViewModifier {
    let title: String
    let description: String?
    let style: HeaderView.Style
    let backAction: (() -> Void)?
    let bottomView: AnyView?
    
    func body(content: Content) -> some View {
        VStack(spacing: .zero) {
            HeaderView(title: title, style: style, description: description, backAction: backAction, bottomView: bottomView)
            content
        }
    }
}

extension View {
    func headerView(title: String, style: HeaderView.Style = .normal, description: String? = nil, backAction: (() -> Void)? = nil, bottomView: AnyView? = nil) -> some View {
        self.modifier(HeaderViewModifier(title: title, description: description, style: style, backAction: backAction, bottomView: bottomView))
    }
}
