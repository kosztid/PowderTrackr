import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "Normal")) {
                ZStack {
                    ScrollView {
                        LazyVStack {
                            if viewModel.tracks.isEmpty {
                                Text("You have no tracks recorded")
                                    .font(.caption)
                                    .foregroundStyle(.gray).opacity(0.7)
                                    .padding(.vertical, 20)
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
                }
                .onAppear(perform: viewModel.onAppear)
                .navigationBarTitleDisplayMode(.inline)
            },
            secondTab: .init(tabItem: .init(name: "Shared")) {
                ZStack {
                    ScrollView {
                        LazyVStack {
                            if viewModel.sharedTracks.isEmpty {
                                Text("You have no tracks shared with you")
                                    .font(.caption)
                                    .foregroundStyle(.gray).opacity(0.7)
                                    .padding(.vertical, 20)
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
                }
                .onAppear(perform: viewModel.onAppear)
                .navigationBarTitleDisplayMode(.inline)
            }
        )
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
}
