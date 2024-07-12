import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            TrackListView()
                .tabItem {
                    Image(systemName: "figure.skiing.downhill")
                    Text("List")
                }
        }
        .tabViewStyle(PageTabViewStyle())
        //        if connectivityProvider.isTracking {
        //            trackingView
        //        } else {
//            homeScreen
//        }
    }
}

#Preview {
    ContentView()
}
