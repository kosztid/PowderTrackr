import SwiftUI

struct ShareListView: View {
    private typealias Str = Rsc.ShareListView
    
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
                                .frame(width: .su32, height: .su32)
                        }
                        Spacer()
                    }
                    list
                        .padding(.horizontal, .su32)

                }
                .padding()
                .background(.white)
                .cornerRadius(.su16)
                .padding(.horizontal, .su32)
                .padding(.vertical, 200)
            }
        }
    }

    var list: some View {
        ScrollView {
            VStack {
                if friends?.friends?.count == .zero {
                    Text(Str.emptyList)
                        .font(.caption)
                        .foregroundStyle(.gray).opacity(0.7)
                        .padding(.vertical, .su20)
                }
                ForEach(friends?.friends ?? []) { friend in
                    HStack {
                        Text(friend.name)
                        Spacer()
                        Button {
                            action(friend)
                        } label: {
                            Text(Str.Button.share)
                        }
                        .buttonStyle(SkiingButtonStyle(style: .secondary))
                    }
                }
            }
        }
    }
}
