import SwiftUI

struct GroupView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("GroupName")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button {
                } label: {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                }
            }
            Divider()
                .padding(8)
            Text("Group Members")
                .padding(.leading, 8)
            List {
                Text("Member 1")
                Text("Member 2")
                Text("Member 3")
                Text("Member 4")
                Text("Member 5")
                Text("Member 76")
            }
            .listStyle(.plain)
        }
        .padding(16)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
