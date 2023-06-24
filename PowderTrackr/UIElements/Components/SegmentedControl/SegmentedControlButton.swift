import SwiftUI

public struct SegmentedControlButton: View {
    var selected: Bool
    var buttonText: String
    var action: () -> Void
    public var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(buttonText)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundColor(selected ? Color.white : Color.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                    .fill(selected ? Color.teal : Color.teal.opacity(0.1))
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
