import SwiftUI

struct RaceManageItemView: View {
    let race: Race
    let shortestTime: String
    let openShare: (String) -> Void
    let viewMyRunsAction: (Race) -> Void
    let dateFormatter = DateFormatter()
    let formatter = DateComponentsFormatter()

    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text("Race")
                    .font(.callout)
                    .bold()
                Spacer()
            }
            HStack {
                Text(race.name)
                    .font(.title)
                Spacer()
                Text(race.date)
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
                Text("\(race.shortestDistance, specifier: "%.2f") meters")
                    .italic()
                Spacer()
                Text("Pank")
                    .bold()
            }
            HStack {
                Text("Best time:")
                Text("\(shortestTime)")
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
                    openShare(race.id)
                } label: {
                    Text("Add participants")
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
            }
            .padding(.top, 8)
        }
    }

    init(
        race: Race,
        openShare: @escaping (String) -> Void,
        viewMyRunsAction: @escaping (Race) -> Void
    ) {
        self.race = race
        self.openShare = openShare
        self.viewMyRunsAction = viewMyRunsAction
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

        self.shortestTime = formatter.string(from: race.shortestTime) ?? ""
    }
}

struct RaceManageItemView_Previews: PreviewProvider {
    static var previews: some View {
        RaceManageItemView(race: Race(name: "Race 123", date: "2023-05-21 11:15:55", shortestTime: 123, shortestDistance: 123), openShare: { _ in}, viewMyRunsAction: { _ in })
    }
}
