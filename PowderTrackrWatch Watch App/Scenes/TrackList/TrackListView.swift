import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            if viewModel.tracks.isEmpty {
                VStack {
                    Text("You have no tracks recorded")
                        .foregroundStyle(Color.warmGray)
                        .padding(.vertical, .su20)
                    Button("Refresh") {
                        viewModel.load()
                    }
                }
            } else {
                trackList
            }
        }
    }

    private var trackList: some View {
        NavigationSplitView {
            List(selection: $viewModel.selectedTrack) {
                ForEach(viewModel.tracks, id: \.id) { track in
                    NavigationLink(value: track) {
                        TrackCell(track: track)
                    }
                }
            }
#if os(watchOS)
            .containerBackground(.blue.gradient, for: .navigation)
#endif
            .padding(.horizontal, .su4)
        } detail: {
            if let track = viewModel.selectedTrack {
                TrackDetail(track: track)
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    TrackListView()
}
