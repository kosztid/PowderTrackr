import SwiftUI

public struct SegmentedControl<Content1: View, Content2: View>: View {
    public struct TabItem: Hashable, Identifiable {
        public let id = UUID()
        let name: String

        public init(name: String) {
            self.name = name
        }
    }

    public struct Tab<Content: View> {
        let tabItem: TabItem
        let content: () -> Content

        public init(
            tabItem: TabItem,
            @ViewBuilder content: @escaping () -> Content
        ) {
            self.tabItem = tabItem
            self.content = content
        }
    }

    @State private var selected = Int.zero

    private let tabItems: [TabItem]
    private let firstTab: () -> Content1
    private let secondTab: () -> Content2

    var tabButtons: some View {
        HStack(alignment: .center, spacing: .zero) {
            ForEach(Array(tabItems.enumerated()), id: \.element) { index, item in
                SegmentedControlButton(selected: index == selected, text: item.name) {
                    withAnimation {
                        selected = index
                    }
                }
                if item != tabItems.last {
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
        .padding(.bottom, 8)
    }

    public var body: some View {
        VStack {
            tabButtons
                .padding(.horizontal, 32)
            TabView(selection: $selected) {
                firstTab()
                    .tag(0)
                secondTab()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarHidden(false)
        }
    }

    public init(
        firstTab: Tab<Content1>,
        secondTab: Tab<Content2>
    ) {
        self.tabItems = [firstTab.tabItem, secondTab.tabItem]
        self.firstTab = firstTab.content
        self.secondTab = secondTab.content
    }
}

#if DEBUG

struct SegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "LISTA")) {
                VStack {
                    Text("123")
                    Text("123")
                    Text("123")
                }
            },
            secondTab: .init(tabItem: .init(name: "LISTB")) {
                VStack {
                    Text("asd")
                    Text("asd")
                    Text("asd")
                }
            }
        )
    }
}

#endif
