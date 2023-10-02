import SwiftUI

struct MyRunsView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                RaceRunView(viewModel: .init(race: "Run 123"))
                RaceRunView(viewModel: .init(race: "Run ABC"))
                RaceRunView(viewModel: .init(race: "Run XYZ"))
            }
        }
        .navigationTitle(viewModel.race)
    }
}

struct MyRunsView_Previews: PreviewProvider {
    static var previews: some View {
        MyRunsView(viewModel: .init(race: "Race 123"))
    }
}
