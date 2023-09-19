import SwiftUI

struct LeaderBoardView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
                .padding(.vertical, 32)
            segmentedButtons
            Divider()
                .frame(height: 2)
            scrollView
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    var segmentedButtons: some View {
        HStack(spacing: .zero) {
            Button {
                viewModel.tabState = .distance
            } label: {
                Text("Distance")
                    .bold()
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(viewModel.tabState == .distance ? .cyan.opacity(0.2) : .white)
                    .cornerRadius(8, corners: [.bottomRight, .topRight])
            }
            Button {
                viewModel.tabState = .time
            } label: {
                Text("Time")
                    .bold()
                    .foregroundColor(.black)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(viewModel.tabState == .time ? .cyan.opacity(0.2) : .white)
                    .cornerRadius(8, corners: [.bottomLeft, .topLeft])
            }
        }
        .padding(.bottom, 8)
    }

    var scrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                ForEach(Array(viewModel.leaderBoardList.enumerated()), id: \.offset) { index, _ in
                    HStack {
                        leaderboardLeadingView(place: index + 1)
                            .font(leaderboardLeadingViewFontSize(place: index + 1))
                            .bold()
                            .foregroundColor(leaderBoardForegroundColor(place: index + 1))
                            .frame(width: 32)
                        Text(viewModel.leaderBoardList[index].name)
                            .font(.body)
                            .bold()
                        Spacer()
                        Text(leaderBoardRowData(index:index))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(leaderBoardBackgroundColor(place: index + 1))
                }
            }
        }
    }

    private func leaderBoardRowData(index: Int) -> String {
        if viewModel.tabState == .distance {
            return "\(String(format: "%.1f", viewModel.leaderBoardList[index].distance / 1000)) Km"
        } else {
            return "\(String(format: "%.f", viewModel.leaderBoardList[index].totalTimeInSeconds / 60)) min"
        }
    }

    private func leaderboardLeadingViewFontSize(place: Int) -> Font {
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
    private func leaderboardLeadingView(place: Int) -> AnyView {
        if place < 4 {
            return AnyView(Image(systemName: "trophy"))
        } else {
            return AnyView(Text(String(place)))
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
