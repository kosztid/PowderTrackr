import SwiftUI

struct MyRunsView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                ForEach(viewModel.raceRuns.indices) { ind in
                    RaceRunView(
                        viewModel: .init(
                            closestRun: viewModel.raceClosestRuns[ind],
                            race: viewModel.raceRuns[ind]
                        )
                    )
                }
            }
        }
        .navigationTitle(viewModel.title)
    }
}
