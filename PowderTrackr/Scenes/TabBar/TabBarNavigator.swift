import SwiftUI

public struct TabBarNavigator: View {
    @State var selectedItem: Int = 0
    
    public var body: some View {
        TabView(selection: $selectedItem) {
            ViewFactory.mapView()
                .tabItem { Label("Map", systemImage: "map") }
                .tag(0)
            ViewFactory.trackListView()
                .tabItem { Label("History", systemImage: "figure.skiing.downhill") }
                .tag(1)
            ViewFactory.raceNavigator()
                .tabItem { Label("Races", systemImage: "flag.2.crossed") }
                .tag(2)
            ViewFactory.leaderBoardView()
                .tabItem { Label("Leaderboard", systemImage: "trophy") }
                .tag(3)
            ViewFactory.socialNavigator()
                .tabItem { Label("Social", systemImage: "person.3.fill") }
                .tag(4)
            
        }
        .toolbarColorScheme(.light, for: .tabBar)
    }
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
