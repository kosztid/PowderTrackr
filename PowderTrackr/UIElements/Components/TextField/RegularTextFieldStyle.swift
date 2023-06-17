import SwiftUI

public struct RegularTextFieldStyleViewModifier: ViewModifier {
    public struct PlaceholderConfig {
        public let placeholder: String
        public let text: String

        public init(placeholder: String, text: String) {
            self.placeholder = placeholder
            self.text = text
        }
    }

    public let label: String?

    public func body(content: Content) -> some View {
        content
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 12)
            .baseTextFieldStyle()
            .textFieldBorder()
            .label(label)
    }
}

public extension TextField {
    func regularTextFieldStyle(
        label: String?
    ) -> some View {
        modifier(RegularTextFieldStyleViewModifier(
            label: label
        ))
    }
}

public extension ToggleableSecureField {
    func regularTextFieldStyle(
        label: String?
    ) -> some View {
        modifier(
            RegularTextFieldStyleViewModifier(
                label: label
            )
        )
    }
}
