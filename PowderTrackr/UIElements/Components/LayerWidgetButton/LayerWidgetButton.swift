import SwiftUI

struct LayerWidgetButton: View {
    private enum Layout {
        static let widgetButtonImageSize: CGFloat = 24
    }

    @Binding var isOpen: Bool

    var body: some View {
        Button {
            withAnimation {
                isOpen.toggle()
            }
        } label: {
            Image(systemName: isOpen ? "xmark" : "text.justify")
                .resizable()
                .frame(width: Layout.widgetButtonImageSize, height: Layout.widgetButtonImageSize)
                .padding(20)
                .foregroundColor(.white)
                .cornerRadius(16)
        }
    }
}
