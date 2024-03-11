import SwiftUI

struct OverlayModalModifier<OverlayView>: ViewModifier where OverlayView: View {
    @Binding var isPresented: Bool
    let overlayView: () -> OverlayView

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                overlayView()
                    .transition(.opacity.combined(with: .scale))
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

extension View {
    func overlayModal<OverlayView>(
        isPresented: Binding<Bool>,
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) -> some View where OverlayView: View {
        self.modifier(OverlayModalModifier(isPresented: isPresented, overlayView: overlayView))
    }
}
