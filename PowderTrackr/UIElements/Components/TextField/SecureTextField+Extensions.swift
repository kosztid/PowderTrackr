import SwiftUI

public extension SecureField where Label == Text {
    init(text: Binding<String>) {
        self.init("", text: text)
    }
}
