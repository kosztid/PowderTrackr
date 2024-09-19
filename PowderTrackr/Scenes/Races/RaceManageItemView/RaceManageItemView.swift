import SwiftUI

struct RaceManageItemView: View {
    private typealias Str = Rsc.RaceManageItemView

    let ownRace: Bool
    let race: Race
    let shortestTime: String
    let openShare: (Race) -> Void
    let viewMyRunsAction: (Race) -> Void
    let dateFormatter = DateFormatter()
    let formatter = DateComponentsFormatter()

    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                Text(Str.Race.label)
                    .textStyle(.bodySmallBold)
                Spacer()
            }
            HStack {
                Text(race.name)
                    .textStyle(.bodyLargeBold)
                Spacer()
                Text(race.date)
                    .textStyle(.bodyLarge)
            }
            if !(race.tracks ?? []).isEmpty {
                Divider().padding(.vertical, .su4)
                dataSection
            }

            Divider().padding(.vertical, .su4)
            managementSection
        }
        .padding(.vertical, .su16)
        .padding(.horizontal, .su8)
        .background(.white)
        .cornerRadius(.su16)
        .customShadow()
    }

    var dataSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Str.Data.Distance.label)
                    .textStyle(.body)
                Text(Str.Data.Distance.description(String(format: "%.2f", race.shortestDistance)))
                    .textStyle(.bodyBold)
                Spacer()
            }
            HStack {
                Text(Str.Data.Time.label)
                    .textStyle(.body)
                Text("\(shortestTime)")
                    .textStyle(.bodyBold)
                Spacer()
            }
        }
    }

    var managementSection: some View {
        Group {
            HStack {
                Button {
                    viewMyRunsAction(race)
                } label: {
                    Text(Str.Button.myRuns)
                }
                .buttonStyle(SkiingButtonStyle(style: .secondary))
                .disabled(race.tracks?.isEmpty ?? true)
                Spacer()
                if ownRace {
                    Button {
                        openShare(race)
                    } label: {
                        Text(Str.Button.share)
                    }
                    .buttonStyle(SkiingButtonStyle(style: .secondary))
                }
            }
            .padding(.top, 8)
        }
    }

    init(
        race: Race,
        openShare: @escaping (Race) -> Void,
        viewMyRunsAction: @escaping (Race) -> Void,
        ownRace: Bool
    ) {
        self.race = race
        self.openShare = openShare
        self.viewMyRunsAction = viewMyRunsAction
        self.ownRace = ownRace
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

        self.shortestTime = formatter.string(from: race.shortestTime) ?? ""
    }
}

struct RaceManageItemView_Previews: PreviewProvider {
    static var previews: some View {
        RaceManageItemView(race: Race(name: "Race 123", date: "2023-05-21 11:15:55", shortestTime: 123, shortestDistance: 123), openShare: { _ in }, viewMyRunsAction: { _ in }, ownRace: true)
    }
}
