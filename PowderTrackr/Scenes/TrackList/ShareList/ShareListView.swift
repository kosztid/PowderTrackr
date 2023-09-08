import SwiftUI

struct ShareListView: View {
    let friends: Friendlist?
    let action: (Friend) -> Void
    let dismissAction: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            VStack {
                VStack {
                    HStack {
                        Button {
                            dismissAction()
                        } label: {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                        Spacer()
                    }
                    list
                    .padding(.horizontal, 32)

                }
                .padding()
                .background(.white)
                .cornerRadius(16)
                .padding(.horizontal, 32)
                .padding(.vertical, 200)
            }
        }
    }

    var list: some View {
        ScrollView {
            VStack {
                ForEach(friends?.friends ?? []) { friend in
                    HStack {
                        Text(friend.name)
                        Spacer()
                        Button {
                            action(friend)
                        } label: {
                            Text("Share")
                        }
                        .buttonStyle(SkiingButtonStyle(style: .secondary))
                    }
                }
            }
        }
    }
}
