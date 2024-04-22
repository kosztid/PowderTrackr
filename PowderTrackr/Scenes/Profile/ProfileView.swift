import Factory
import SwiftUI

struct ProfileView: View {
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
                    Text("Select an option to continue")
                        .textStyle(.body)
                        .foregroundColor(.gray)
                        .padding(.vertical, .su32)
                    Button {
                        viewModel.login()
                    } label: {
                        Text("Login")
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                    }
                    .buttonStyle(SkiingButtonStyle())
                    .padding(.bottom, .su16)
                    Button {
                        viewModel.register()
                    } label: {
                        Text("Register")
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                    }
                    .buttonStyle(SkiingButtonStyle())
                    .padding(.bottom, .su16)
                    Text("Please login or create an account to continue")
                        .textStyle(.body)
                        .padding(.bottom, .su16)
                        .foregroundColor(.gray)
                }
            }
            .headerView(
                title: "Welcome to PowderTrackr",
                description: "To track your snowy adventures"
            )
    }
    
    var loggedInView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .su16) {
                stats
                    .floatingRoundedCardBackground()
                userData
                    .floatingRoundedCardBackground()
                HStack {
                    Button("Update password") {
                        viewModel.updatePasswordTap()
                    }
                    .buttonStyle(SkiingButtonStyle(style: .bordered))
                    Spacer()
                    Button("Logout") {
                        viewModel.logout()
                    }
                    .buttonStyle(SkiingButtonStyle(style: .primary))
                }
                .padding(.horizontal, .su8)
            }
            .padding(.su8)
        }
        .background(Color.grayPrimary)
        .headerView(
            title: "Profile"
        )
    }

    var userData: some View {
        VStack(spacing: 16) {
            Text("You")
                .bold()
                .font(.title)
            VStack(alignment: .leading, spacing: .zero) {
                Text("Email address")
                    .foregroundColor(.gray)
                    .font(.caption)
                Text(viewModel.currentEmail)
                Divider()
                    .padding(.vertical, 4)
                Text("Name")
                    .foregroundColor(.gray)
                    .font(.caption)
                Text(viewModel.userName)
            }
        }
    }

    var stats: some View {
        VStack(spacing: 16) {
            Text("Stats")
                .bold()
                .font(.title)
            HStack {
                Text("Total distance on snow:")
                Spacer()
                Text("\(viewModel.totalDistance / 1_000.0, specifier: "%.2f") km")
            }
            HStack {
                Text("Total time on snow:")
                Spacer()
                Text("\(viewModel.totalTime)")
            }
        }
    }
}
