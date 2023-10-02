import SwiftUI

struct RacesView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                RaceManageItemView(race: "Race 123", viewMyRunsAction: viewModel.navigateToMyRuns)
                RaceManageItemView(race: "Race XYZ", viewMyRunsAction: viewModel.navigateToMyRuns)
                RaceManageItemView(race: "Race ABC", viewMyRunsAction: viewModel.navigateToMyRuns)
            }
        }

    }
}
//
//struct RacesView_Previews: PreviewProvider {
//    static var previews: some View {
//        RacesView(viewModel: .init())
//    }
//}
