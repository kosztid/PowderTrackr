import SwiftUI

struct FriendAddRowView: View {
    var user: User
    let addAction: (User) -> Void

    var body: some View {
        HStack {
            Text(user.name)
                .textStyle(.bodyLarge)
                .foregroundColor(Color.primary)

            Spacer()

            Button {
                addAction(user)
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.darkSlateGray)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.cyanPrimary.opacity(0.8), Color.cyanPrimary]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, .su16)
        .frame(height: .su64)
        .background(Color.softWhite)
        .cornerRadius(.su8)
        .padding([.top, .horizontal], .su10)
        .customShadow(style: .light)
    }
}
