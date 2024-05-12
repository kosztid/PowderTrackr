import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        if viewModel.isTracking {
            trackingView
        } else {
            homeScreen
        }
    }
    
    private var homeScreen: some View {
        Text("You are currently not tracking a run")
    }
    
    private var trackingView: some View {
        VStack {
            HStack(spacing: .zero) {
                HStack {
                    Image(systemName: "arrow.forward")
                        .resizable()
                        .frame(width: .su10, height: .su10)
                    Text("distance")
                        .font(.caption2)
                }
                .foregroundStyle(Color.gray)
                Spacer()
                Text("\(String(format: "%.f", connectivityProvider.distance)) m")
                    .font(.caption2)
                    .bold()
            }
            Divider()
                .padding(.horizontal, .su12)
            HStack(spacing: .zero) {
                HStack {
                    Image(systemName: "timer")
                        .resizable()
                        .frame(width: .su10, height: .su10)
                    Text("total time")
                        .font(.caption2)
                }
                .foregroundStyle(Color.gray)
                Spacer()
                Text("\(String(format: "%.2f", connectivityProvider.elapsedTime)) s")
                    .font(.caption)
                    .bold()
            }
            Divider()
                .padding(.horizontal, .su12)
            HStack(spacing: .zero) {
                HStack {
                    Image(systemName: "speedometer")
                        .resizable()
                        .frame(width: .su10, height: .su10)
                    Text("avg speed")
                        .font(.caption2)
                }
                .foregroundStyle(Color.gray)
                Spacer()
                Text("\(String(format: "%.2f", connectivityProvider.avgSpeed)) km/h")
                    .font(.caption)
                    .bold()
            }
        }
    }
    
    init() {
        self.viewModel = ViewModel()
    }
}

#Preview {
    HomeView()
}
