import SwiftUI

public struct ToggleableSecureField: View {
    @Environment(\.isEnabled) private var isEnabled

    @Binding var text: String
    @State private var isSecure = true

    public var body: some View {
        HStack(spacing: .zero) {
            if isSecure {
                SecureField(text: $text)
            } else {
                TextField(text: $text)
            }
            Button {
                isSecure.toggle()
            } label: {
                if isSecure {
                    Image(systemName: "eye")
                } else {
                    Image(systemName: "eye.slash")
                }
            }
        }
    }

    public init(text: Binding<String>) {
        self._text = text
    }
}
