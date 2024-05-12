import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if viewModel.tracks.isEmpty {
                    Text("You have no tracks recorded")
                        .textStyle(.bodySmall)
                        .foregroundStyle(Color.warmGray)
                        .padding(.vertical, .su20)
                }
                ForEach(viewModel.tracks) { track in
                    Text(track.name)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    init() {
        self.viewModel = ViewModel()
    }
}

#Preview {
    TrackListView()
}
