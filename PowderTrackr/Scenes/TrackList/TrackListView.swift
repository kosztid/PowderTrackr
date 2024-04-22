import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "Normal")) {
                normalTab
            },
            secondTab: .init(tabItem: .init(name: "Shared")) {
                sharedTab
            }
        )
        .background(Color.grayPrimary)
        .overlayModal(isPresented: .constant(!viewModel.signedIn)) {
            LoggedOutModal(action: viewModel.model.navigateToAccount)
        }
        .overlay {
            if viewModel.trackToShare != nil {
                ShareListView(friends: viewModel.friendList) { friend in
                    viewModel.share(with: friend)
                } dismissAction: {
                    viewModel.trackToShare = nil
                }
            }
        }
        .toolbar(.hidden)
    }
    
    var normalTab: some View {
        ScrollView {
            LazyVStack {
                if viewModel.tracks.isEmpty {
                    Text("You have no tracks recorded")
                        .textStyle(.bodySmall)
                        .foregroundStyle(Color.warmGray)
                        .padding(.vertical, .su20)
                }
                ForEach(viewModel.tracks) { track in
                    TrackListItem(
                        track: track,
                        shareAction: viewModel.shareTrack,
                        updateAction: viewModel.updateTrack,
                        noteAction: viewModel.addNote,
                        deleteAction: viewModel.removeTrack,
                        totalDistance: viewModel.calculateDistance(track: track)
                    )
                    .listRowSeparator(.hidden)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: viewModel.onAppear)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var sharedTab: some View {
        ScrollView {
            LazyVStack {
                if viewModel.sharedTracks.isEmpty {
                    Text("You have no tracks shared with you")
                        .textStyle(.bodySmall)
                        .foregroundStyle(Color.warmGray)
                        .padding(.vertical, .su20)
                }
                ForEach(viewModel.sharedTracks) { track in
                    TrackListItem(
                        track: track,
                        style: .shared,
                        updateAction: viewModel.updateTrack,
                        deleteAction: viewModel.removeSharedTrack,
                        totalDistance: viewModel.calculateDistance(track: track)
                    )
                    .listRowSeparator(.hidden)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: viewModel.onAppear)
        .navigationBarTitleDisplayMode(.inline)
    }
}
