import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "Mine")) {
                ZStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.tracks) { track in
                                TrackListItem(
                                    track: track,
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
                VStack {
                    Text("path1")
                    Text("path2")
                    Text("path3")
                }
            }
        )
        .overlay {
            if !viewModel.signedIn {
                LoggedOutModal()
            }
        }
    }
}
