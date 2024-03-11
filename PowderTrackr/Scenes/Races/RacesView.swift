import SwiftUI

struct RacesView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if viewModel.races.isEmpty {
                        Text("You have no races so far...")
                            .font(.caption)
                            .foregroundStyle(.gray).opacity(0.7)
                            .padding(.vertical, 20)
                    }
                    ForEach(viewModel.races) { race in
                        RaceManageItemView(
                            race: race,
                            openShare: viewModel.openShare,
                            viewMyRunsAction: viewModel.navigateToMyRuns,
                            ownRace: race.participants?[0] == viewModel.userID
                        )
                    }
                }
            }
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
        .overlayModal(isPresented: .constant(!viewModel.signedIn)) {
            LoggedOutModal {
                viewModel.inputModel.navigateToAccount()
            }
        }
        .toolbar(.hidden)
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
        .onAppear {
            viewModel.refreshRaces()
        }
    }
}
