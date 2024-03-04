import SwiftUI

public struct ToastModifier: ViewModifier {
    private enum Constants {
        static let shadowOpacity: CGFloat = 0.3
        static let opacityVisible: CGFloat = 1.0
        static let opacityInvisible: CGFloat = 0.0
        static let animationDuration: CGFloat = 0.5
        static let animationDelay: CGFloat = 4.0
    }

    @State private var showToastAnimation = false
    @Binding var toastMessage: ToastModel?

    public func body(content: Content) -> some View {
        content
            .overlay {
                if let toastMessage, showToastAnimation {
                    VStack {
                        Spacer()
                        toast(toastMessage: toastMessage)
                    }
                }
            }
            .onChange(of: toastMessage) { _, newValue in
                if newValue == nil { return }
                withAnimation(.linear(duration: Constants.animationDuration)) {
                    showToastAnimation = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationDelay) {
                    withAnimation(.linear(duration: Constants.animationDuration)) {
                        showToastAnimation = false
                        toastMessage = nil
                    }
                }
            }
    }

    func toast(toastMessage: ToastModel) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(toastMessage.title)
                    .font(.body)
                    .bold()
                    .foregroundColor(toastMessage.type.textColor)
//                if let description = toastMessage.description {
//                    Text(description)
//                        .textStyle(.body)
//                        .foregroundColor(toastMessage.type.textColor)
//                        .accessibilityIdentifier(Accessibility.description)
//                }
            }
            .padding(8)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(toastMessage.type.backgroundColor)
        .cornerRadius(8, corners: .allCorners)
        .padding(8)
        .shadow(
            color: Color.blue.opacity(Constants.shadowOpacity),
            radius: 24,
            x: .zero,
            y: 12
        )
        .opacity(showToastAnimation ? Constants.opacityVisible : Constants.opacityInvisible)
    }
}

private extension ToastModel.ToastType {
    var textColor: Color {
        switch self {
        case .success: return Color.white
        case .error: return Color.white
        }
    }

    var backgroundColor: Color {
        switch self {
        case .success: return Color.green
        case .error: return Color.red
        }
    }
}

public extension View {
    func toastMessage(
        toastMessage: Binding<ToastModel?>
    ) -> some View {
        modifier(
            ToastModifier(toastMessage: toastMessage)
        )
    }
}
