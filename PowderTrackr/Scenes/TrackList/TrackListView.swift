import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "Friends")) {
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
            secondTab: .init(tabItem: .init(name: "Groups")) {
                VStack {
                    Text("group1")
                    Text("group2")
                    Text("group3")
                }
            }
        )

    }
}
