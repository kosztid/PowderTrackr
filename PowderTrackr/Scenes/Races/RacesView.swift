import SwiftUI

struct RacesView: View {
    @StateObject var viewModel: ViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RacesView_Previews: PreviewProvider {
    static var previews: some View {
        RacesView(viewModel: .init())
    }
}
