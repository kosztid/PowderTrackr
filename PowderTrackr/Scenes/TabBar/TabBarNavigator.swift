import SwiftUI

public struct TabBarNavigator: View {
    @State var selectedItem: Int = 0

    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedItem) {
                ViewFactory.mapView()
                    .tabItem { Image(systemName: "map") }
                    .tag(0)
                ViewFactory.trackListView()
                    .tabItem { Image(systemName: "figure.skiing.downhill") }
                    .tag(1)
                ViewFactory.socialNavigator()
                    .tabItem { Image(systemName: "person.3.fill") }
                    .tag(2)
                ViewFactory.profileNavigator()
                    .tabItem { Image(systemName: "person") }
                    .tag(3)
            }
        }
    }

    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
