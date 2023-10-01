import SwiftUI

struct RacesView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                RaceRunView(viewModel: .init(race: "Race 123"))
                RaceRunView(viewModel: .init(race: "Race XYZ"))
                RaceRunView(viewModel: .init(race: "Race ABC"))
            }
        }

    }
}

struct RacesView_Previews: PreviewProvider {
    static var previews: some View {
        RacesView(viewModel: .init())
    }
}
