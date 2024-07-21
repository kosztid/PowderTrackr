import SwiftUI

public struct FriendAddView: View {
    private typealias Str = Rsc.FriendAddView

    @StateObject var viewModel: ViewModel

    public var body: some View {
        ScrollView {
            VStack(spacing: .zero) {
                if viewModel.users.isEmpty {
                    Text(Str.EmptyList.description)
                        .textStyle(.bodyBold)
                        .foregroundStyle(Color.warmGray)
                        .padding()
                    Spacer()
                } else {
                    ForEach(viewModel.filteredUsers, id: \.self) { user in
                        FriendAddRowView(user: user, addAction: viewModel.addFriend)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.grayPrimary)
        .toastMessage(toastMessage: $viewModel.toast)
        .headerView(title: Str.Header.title, backAction: viewModel.dismissButtonTap, bottomView: AnyView(searchBar))
    }

    @ViewBuilder var searchBar: some View {
        TextField(Str.SearchBar.label, text: $viewModel.searchText)
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
