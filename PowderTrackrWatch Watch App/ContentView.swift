import SwiftUI

public struct ContentView: View {
    public var body: some View {
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
#if os(watchOS)
        .tabViewStyle(PageTabViewStyle())
#endif
    }
}

#Preview {
    ContentView()
}
