import SwiftUI

public struct FriendAddView: View {
    @StateObject var viewModel: ViewModel
    
    public var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.filteredUsers, id: \.self) { user in
                    FriendAddRowView(user: user, addAction: viewModel.addFriend)
                }
            }
        }
        .background(Color.grayPrimary)
        .toastMessage(toastMessage: $viewModel.toast)
        .headerView(title: "Add friends to ski with", style: .inline, backAction: viewModel.dismissButtonTap, bottomView: AnyView(searchBar))
    }
    
    @ViewBuilder var searchBar: some View {
        TextField("Search...", text: $viewModel.searchText)
            .padding(.su8)
            .padding(.horizontal, .su24)
            .background(Color.white)
            .cornerRadius(.su8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, .su8)
                }
            )
            .padding(.horizontal, .su10)
    }
}
