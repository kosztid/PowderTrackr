import SwiftUI

struct RaceManageItemView: View {
    let race: String
    let openShare: (String) -> Void
    let viewMyRunsAction: (String) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("Race")
                    .font(.callout)
                    .bold()
                Spacer()
            }
            HStack {
                Text(race)
                    .font(.title)
                Spacer()
                Text("2023-09-30")
            }
            Divider().padding(.vertical, 4)
            dataSection
            Divider().padding(.vertical, 4)
            managementSection
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(.white)
        .cornerRadius(16)
        .padding(8)
        .customShadow()
    }

    var dataSection: some View {
        Group {
            HStack {
                Text("Shortest run:")
                Text("11324 meters")
                    .italic()
                Spacer()
                Text("Pank")
                    .bold()
            }
            HStack {
                Text("Best time:")
                Text("12:32 min")
                    .italic()
                Spacer()
                Text("Dominik")
                    .bold()
            }
        }
    }

    var managementSection: some View {
        Group {
            HStack {
                Button {
                    viewMyRunsAction(race)
                } label: {
                    Text("View my runs")
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
                Spacer()
                Button {
                    openShare(race)
                } label: {
                    Text("Add participants")
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
            }
            .padding(.top, 8)
        }
    }
}

struct RaceManageItemView_Previews: PreviewProvider {
    static var previews: some View {
        RaceManageItemView(race: "Race 123", openShare: { _ in}, viewMyRunsAction: { _ in })
    }
}
