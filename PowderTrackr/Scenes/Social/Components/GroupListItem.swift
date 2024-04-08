import SwiftUI

struct GroupListItem: View {
//    var group: FriendGroup
    var body: some View {
        HStack {
            Text("groupname")
                .font(.headline)
            Spacer()
            Text("(12)")
                .foregroundColor(.gray.opacity(0.8))
        }
        .padding(.su16)
    }
}

struct GroupListItem_Previews: PreviewProvider {
    static var previews: some View {
        GroupListItem()
    }
}
