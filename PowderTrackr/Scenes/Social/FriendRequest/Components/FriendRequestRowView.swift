import SwiftUI

struct FriendRequestRowView: View {
    var requester: String
    let acceptAction: () -> Void
    let declineAction: () -> Void

    var body: some View {
        HStack {
            Text(requester)
                .textStyle(.bodyLarge)
                .foregroundColor(Color.primary)
            
            Spacer()
            
            Button(action: acceptAction) {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.cyanPrimary.opacity(0.8), Color.cyanPrimary]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
            }
            .padding(.trailing, .su4)
            
            Button(action: declineAction) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.redUtility.opacity(0.8), Color.redUtility]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
            }
            .padding(.trailing, .su10)
        }
        .padding(.leading, .su16)
        .frame(height: .su64)
        .background(Color.softWhite)
        .cornerRadius(.su8)
        .padding([.top, .horizontal], .su10)
        .customShadow(style: .light)
    }
}
