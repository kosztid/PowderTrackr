import SwiftUI

public extension TextField where Label == Text {
    init(text: Binding<String>) {
        self.init("", text: text)
    }
}
