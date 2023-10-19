import SwiftUI

struct MyRunsView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                ForEach(Array(viewModel.raceRuns.enumerated()), id: \.element) { index, race in
                    RaceRunView(
                        viewModel: .init(
                            closestRun: viewModel.raceClosestRuns[index],
                            race: race
                        )
                    )
                }
            }
        }
        .navigationTitle(viewModel.title)
    }
}
