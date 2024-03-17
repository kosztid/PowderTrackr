import SwiftUI

struct FriendRequestRowView: View {
    var requester: String
    let acceptAction: () -> Void
    let declineAction: () -> Void

    var body: some View {
        HStack {
            Text(requester)
                .font(.system(size: 18, weight: .medium, design: .default))
                .foregroundColor(Color.primary)
                .padding(.leading, 10)
            
            Spacer()
            
            Button(action: acceptAction) {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.cyanPrimary.opacity(0.8), Color.cyanPrimary]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
            }
            .padding(.trailing, 5)
            
            Button(action: declineAction) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.redUtility.opacity(0.8), Color.redUtility]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
            }
            .padding(.trailing, 10)
        }
        .frame(height: 60)
        .background(Color.softWhite)
        .cornerRadius(8)
        .padding([.top, .horizontal], 10)
        .customShadow(style: .light)
    }
}
