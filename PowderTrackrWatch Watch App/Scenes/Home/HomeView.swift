import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isTracking {
                trackingView
            } else {
                homeScreen
            }
        }
        
    }
    
    private var homeScreen: some View {
        VStack {
            Text("You are currently not tracking a run")
            Button("Start") {
                viewModel.startTracking()
            }
        }
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
                Text("\(String(format: "%.f", viewModel.distance)) m")
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
                Text("\(String(format: "%.2f", viewModel.elapsedTime)) s")
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
                Text("\(String(format: "%.2f", viewModel.avgSpeed)) km/h")
                    .font(.caption)
                    .bold()
            }
            Button("Stop") {
                viewModel.stopTracking()
            }
        }
    }
}

#Preview {
    HomeView()
}
