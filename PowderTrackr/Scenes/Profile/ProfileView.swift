import Factory
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        if viewModel.isSignedIn {
            loggedInView
                .onAppear(perform: viewModel.loadData)
        } else {
            loggedOutView
        }
    }

    var loggedOutView: some View {
        VStack(spacing: .zero) {
            ZStack {
                Color.teal
                    .ignoresSafeArea()
                VStack(spacing: .zero) {
                    Text("Welcome to Skiing")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 16)
                    Text("To track your snowy adventures")
                        .font(.title3)
                        .bold()
                }
                .foregroundColor(.white)
            }
            .frame(height: 200)
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    Text("Select an option to continue")
                        .foregroundColor(.gray)
                        .padding(.vertical, 32)
                    Button {
                        viewModel.login()
                    } label: {
                        Text("Login")
                            .font(.title3)
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                    }
                    .buttonStyle(SkiingButtonStyle())
                    .padding(.bottom, 16)
                    Button {
                        viewModel.register()
                    } label: {
                        Text("Register")
                            .font(.title3)
                            .frame(width: UIScreen.main.bounds.width * 0.6)
                    }
                    .buttonStyle(SkiingButtonStyle())
                    .padding(.bottom, 16)
                    Text("Please login or create an account to continue")
                        .padding(.bottom, 16)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    var loggedInView: some View {
        VStack(spacing: .zero) {
            ZStack {
                Color.teal
                    .ignoresSafeArea()
                Text("Profile")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.vertical, 24)
            }
            .frame(height: 120)
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    stats
                    Divider()
                        .padding(.vertical, 8)
                    userData
                    Divider()
                        .padding(.vertical, 8)
                    Divider()
                        .padding(.vertical, 8)
                    HStack {
                        Button {
                            viewModel.updatePasswordTapped()
                        } label: {
                            Text("Update password")
                        }
                        .buttonStyle(SkiingButtonStyle(style: .bordered))
                        Spacer()
                        Button {
                            viewModel.logout()
                        } label: {
                            Text("Logout")
                        }
                        .buttonStyle(SkiingButtonStyle(style: .secondary))
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }

    var userData: some View {
        VStack(spacing: .zero) {
            Text("You")
                .bold()
                .padding(.vertical, 16)
                .font(.title)
            VStack(alignment: .leading, spacing: .zero) {
                Text("Email address")
                    .foregroundColor(.gray)
                    .font(.caption)
                Text(viewModel.currentEmail ?? "")
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
        VStack(spacing: .zero) {
            Text("Stats")
                .bold()
                .padding(.vertical, 16)
                .font(.title)
            HStack {
                Text("Total distance on snow:")
                Spacer()
                Text("\(viewModel.totalDistance / 1_000.0, specifier: "%.2f") km")
            }
            .padding(.vertical, 8)
            HStack {
                Text("Total time on snow:")
                Spacer()
                Text("\(viewModel.totalTime)")
            }
            .padding(.vertical, 8)
        }
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
