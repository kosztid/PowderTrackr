import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "Normal")) {
                ZStack {
                    ScrollView {
                        LazyVStack {
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
                            ForEach(viewModel.sharedTracks) { track in
                                TrackListItem(
                                    track: track,
                                    style: .shared,
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
        .overlay {
            if !viewModel.signedIn {
                LoggedOutModal()
            }
        }
    }
}
