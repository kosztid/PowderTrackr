import SwiftUI

struct RacesView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.races.isEmpty {
                    Text("You have no races so far...")
                        .textStyle(.bodySmall)
                        .foregroundStyle(Color.warmGray)
                        .padding(.vertical, .su20)
                }
                ForEach(viewModel.races) { race in
                    RaceManageItemView(
                        race: race,
                        openShare: viewModel.openShare,
                        viewMyRunsAction: viewModel.navigateToMyRuns,
                        ownRace: race.participants?[.zero] == viewModel.userID
                    )
                }
            }
            .padding(.su8)
        }
        .frame(maxWidth: .infinity)
        .background(Color.grayPrimary)
        .overlay {
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
            Button("delete", role: .destructive) {
                viewModel.deleteRace()
                viewModel.showingDeleteRaceAlert.toggle()
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
