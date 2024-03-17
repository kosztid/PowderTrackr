import SwiftUI

public struct SegmentedControlButton: View {
    var selected: Bool
    var buttonText: String
    var action: () -> Void
    public var body: some View {
        Button {
            action()
        } label: {
            Text(buttonText)
                .foregroundColor(selected ? .darkSlateGray : .black)
                .padding(.vertical, 10)
                .overlay(
                    Rectangle()
                        .frame(height: selected ? 2 : 0)
                        .foregroundColor(.darkSlateGray),
                    alignment: .bottom
                )
        }
    }

    public init(selected: Bool, text: String, action: @escaping () -> Void) {
        self.selected = selected
        self.buttonText = text
        self.action = action
    }
}

struct GameSegmentedControlButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SegmentedControlButton(selected: true, text: "Gamebutton", action: {})
            SegmentedControlButton(selected: false, text: "Gamebutton", action: {})
        }
    }
}
