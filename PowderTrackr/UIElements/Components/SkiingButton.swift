import SwiftUI

public struct SkiingButton: View {
    var text: String
    public var body: some View {
        Button {
        } label: {
            Text(text)
        }
    }

    public init(text: String) {
        self.text = text
    }
}
