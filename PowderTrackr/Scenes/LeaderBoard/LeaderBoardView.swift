import SwiftUI

struct LeaderBoardView: View {
    private typealias Str = Rsc.LeaderBoardView
    
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Text("Leaderboard")
                .textStyle(.h2)
                .padding(.bottom, .su16)
            segmentedButtons
            Divider()
                .frame(height: .su2)
            scrollView
        }
        .background(Color.grayPrimary)
        .onAppear {
            viewModel.onAppear()
        }
        .toolbar(.hidden)
    }

    var segmentedButtons: some View {
        HStack(spacing: .zero) {
            Button {
                viewModel.tabState = .distance
            } label: {
                Text(Str.Data.Distance.label)
                    .textStyle(.bodyLargeBold)
                    .foregroundColor(.black)
                    .frame(minWidth: .zero, maxWidth: .infinity)
                    .padding(.vertical, .su8)
                    .background(viewModel.tabState == .distance ? Color.cyanPrimary : Color.softWhite)
                    .cornerRadius(.su8, corners: [.bottomRight, .topRight])
            }
            Button {
                viewModel.tabState = .time
            } label: {
                Text(Str.Data.Time.label)
                    .textStyle(.bodyLargeBold)
                    .foregroundColor(.black)
                    .frame(minWidth: .zero, maxWidth: .infinity)
                    .padding(.vertical, .su8)
                    .background(viewModel.tabState == .time ? Color.cyanPrimary : Color.softWhite)
                    .cornerRadius(.su8, corners: [.bottomLeft, .topLeft])
            }
        }
        .padding(.bottom, .su8)
    }

    var scrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                ForEach(Array(viewModel.leaderBoardList.enumerated()), id: \.offset) { index, _ in
                    HStack {
                        leaderboardLeadingView(place: index + 1)
                            .foregroundColor(leaderBoardForegroundColor(place: index + 1))
                            .frame(width: .su32)
                        Text(viewModel.leaderBoardList[index].name)
                            .textStyle(.bodyLargeBold)
                        Spacer()
                        Text(leaderBoardRowData(index:index))
                            .textStyle(.bodyLarge)
                            .foregroundStyle(Color.darkSlateGray)
                    }
                    .padding(.vertical, .su8)
                    .padding(.horizontal)
                    .background(leaderBoardBackgroundColor(place: index + 1))
                }
            }
        }
    }

    private func leaderBoardRowData(index: Int) -> String {
        if viewModel.tabState == .distance {
            return Str.Row.Distance.label(String(format: "%.1f", viewModel.leaderBoardList[index].distance / 1000))
        } else {
            return Str.Row.Time.label(String(format: "%.f", viewModel.leaderBoardList[index].totalTimeInSeconds / 60))
        }
    }
    
    private func leaderboardLeadingView(place: Int) -> AnyView {
        if place < 4 {
            return AnyView(
                Image(systemName: "trophy")
                .font(leaderboardLeadingViewImageSize(place: place))
            )
        } else {
            return AnyView(
                Text(String(place))
                    .textStyle(leaderboardLeadingViewFontSize(place: place))
            )
        }
    }

    private func leaderboardLeadingViewFontSize(place: Int) -> TextStyle {
        if place == 1 {
            return .h2
        } else if place == 2 {
            return .h3
        } else if place == 3 {
            return .bodyLarge
        } else {
            return .bodyLarge
        }
    }    
    
    private func leaderboardLeadingViewImageSize(place: Int) -> Font {
        if place == 1 {
            return .title
        } else if place == 2 {
            return .title2
        } else if place == 3 {
            return .title3
        } else {
            return .title3
        }
    }

    private func leaderBoardForegroundColor(place: Int) -> Color {
        if place == 1 {
            return Color("Gold")
        } else if place == 2 {
            return Color("Silver")
        } else if place == 3 {
            return Color("Bronze")
        } else {
            return .black
        }
    }

    private func leaderBoardBackgroundColor(place: Int) -> Color {
        if place == 1 {
            return Color("Gold").opacity(0.4)
        } else if place == 2 {
            return Color("Silver").opacity(0.4)
        } else if place == 3 {
            return Color("Bronze").opacity(0.4)
        } else {
            return .white
        }
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView(viewModel: .init(statservice: StatisticsService()))
    }
}
