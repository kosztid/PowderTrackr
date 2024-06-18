import Factory
import SwiftUI

struct ProfileView: View {
    private typealias Str = Rsc.ProfileView

    @StateObject var viewModel: ViewModel

    var body: some View {
       profileViewBase
    }

    @ViewBuilder var profileViewBase: some View {
        if viewModel.isSignedIn {
            loggedInView
                .onAppear(perform: viewModel.loadData)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewModel.dismissButtonTap()
                        } label: {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
        } else {
            loggedOutView
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewModel.dismissButtonTap()
                        } label: {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
        }
    }
    var loggedOutView: some View {
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text(Str.LoggedOut.title)
                        .textStyle(.body)
                        .foregroundColor(.gray)
                        .padding(.vertical, .su32)
                    Button {
                        viewModel.login()
                    } label: {
                        Text(Str.Button.login)
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                    }
                    .buttonStyle(SkiingButtonStyle())
                    .padding(.bottom, .su16)
                    Button {
                        viewModel.register()
                    } label: {
                        Text(Str.Button.register)
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                    }
                    .buttonStyle(SkiingButtonStyle())
                    .padding(.bottom, .su16)
                    Text(Str.LoggedOut.description)
                        .textStyle(.body)
                        .padding(.bottom, .su16)
                        .foregroundColor(.gray)
                }
            }
            .headerView(description: Str.Header.description)
    }

    var loggedInView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .su16) {
                stats
                    .floatingRoundedCardBackground()
                userData
                    .floatingRoundedCardBackground()
                HStack {
                    Button(Str.Button.updatePassword) {
                        viewModel.updatePasswordTap()
                    }
                    .buttonStyle(SkiingButtonStyle(style: .bordered))
                    Spacer()
                    Button(Str.Button.logout) {
                        viewModel.logout()
                    }
                    .buttonStyle(SkiingButtonStyle(style: .primary))
                }
                .padding(.horizontal, .su8)
            }
            .padding(.su8)
        }
        .background(Color.grayPrimary)
        .headerView(title: Str.Header.Profile.title)
        .onAppear {
            viewModel.loadData()
        }
    }

    var userData: some View {
        VStack(spacing: .su16) {
            Text(Str.Data.you)
                .textStyle(.h2)
            VStack(alignment: .leading, spacing: .zero) {
                Text(Str.Data.email)
                    .textStyle(.bodySmall)
                    .foregroundStyle(Color.warmGray)
                Text(viewModel.currentEmail)
                    .textStyle(.body)
                Divider()
                    .padding(.vertical, .su4)
                Text(Str.Data.name)
                    .textStyle(.bodySmall)
                    .foregroundStyle(Color.warmGray)
                Text(viewModel.userName)
                    .textStyle(.body)
            }
        }
    }

    var stats: some View {
        VStack(spacing: .su16) {
            Text(Str.Stats.label)
                .textStyle(.h2)
            HStack {
                Text(Str.Stats.Distance.label)
                    .textStyle(.body)
                Spacer()
                Text(Str.Stats.Distance.description((viewModel.totalDistance / 1_000.0, specifier: "%.2f")))
                    .textStyle(.bodyBold)
            }
            HStack {
                Text(Str.Stats.Time.label)
                    .textStyle(.body)
                Spacer()
                Text("\(viewModel.totalTime)")
                    .textStyle(.bodyBold)
            }
        }
    }
}
