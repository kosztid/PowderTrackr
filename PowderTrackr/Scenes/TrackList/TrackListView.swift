import SwiftUI

struct TrackListView: View {
    private typealias Str = Rsc.TrackListView

    @StateObject var viewModel: ViewModel

    var body: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: Str.Tabs.normal)) {
                normalTab
            },
            secondTab: .init(tabItem: .init(name: Str.Tabs.shared)) {
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
                    Text(Str.List.Normal.empty)
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
                    Text(Str.List.Shared.empty)
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
