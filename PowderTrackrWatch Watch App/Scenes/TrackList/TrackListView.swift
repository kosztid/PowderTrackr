import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.tracks.isEmpty {
                    Text("You have no tracks recorded")
                        .foregroundStyle(Color.warmGray)
                        .padding(.vertical, .su20)
                }
                ForEach(viewModel.tracks) { track in
                    HStack {
                        Text(track.name)
                        Spacer()
                        Text("\(viewModel.calculateDistance(track: track), specifier: "%.f") m")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear { viewModel.load() }
    }
}

#Preview {
    TrackListView()
}
