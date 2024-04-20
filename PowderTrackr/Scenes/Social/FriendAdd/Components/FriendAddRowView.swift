import SwiftUI

struct FriendAddRowView: View {
    var user: User
    let addAction: (String) -> Void

    var body: some View {
        HStack {
            Text(user.name)
                .textStyle(.body)
                .foregroundColor(Color.primary)
                .padding(.leading, 10)
            
            Spacer()
            
            Button {
                addAction(user.email)
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.cyanPrimary.opacity(0.8), Color.cyanPrimary]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
            }
            .padding(.trailing, .su4)
        }
        .frame(height: .su64)
        .background(Color.softWhite)
        .cornerRadius(.su8)
        .padding([.top, .horizontal], .su10)
        .customShadow(style: .light)
    }
}
