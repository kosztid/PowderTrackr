import SwiftUI

struct RacesView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.races, id: \.self) { race in
                    RaceManageItemView(
                        race: race,
                        openShare: viewModel.openShare,
                        viewMyRunsAction: viewModel.navigateToMyRuns
                    )
                    .swipeActions {
                        Button(role: .cancel) {
                            viewModel.raceToDelete = race
                            viewModel.showingDeleteRaceAlert = true
                        } label: {
                            Text("Delete")
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(PlainListStyle())
            if viewModel.raceToShare != nil {
                ShareListView(friends: viewModel.friendList) { friend in
                    viewModel.share(with: friend)
                } dismissAction: {
                    withAnimation {
                        viewModel.raceToShare = nil
                    }
                }
            }
        }
        .alert("Are you sure want to delete this race?", isPresented: $viewModel.showingDeleteRaceAlert) {
            Button(role: .destructive) {
                viewModel.deleteRace()
                viewModel.showingDeleteRaceAlert.toggle()
            } label: {
                Text("Delete")
            }
            Button(
                "Cancel",
                role: .cancel
            ) {
                viewModel.refreshRaces()
                viewModel.showingDeleteRaceAlert.toggle()
            }
        }
    }
}
