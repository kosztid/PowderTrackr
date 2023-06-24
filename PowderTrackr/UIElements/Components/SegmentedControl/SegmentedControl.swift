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

    @Binding var isViewInFocus: Bool

    private let tabItems: [TabItem]
    private let firstTab: () -> Content1
    private let secondTab: () -> Content2

    var tabButtons: some View {
        VStack {
            ZStack(alignment: .trailing) {
                HStack(alignment: .center, spacing: .zero) {
                    ForEach(Array(tabItems.enumerated()), id: \.element) { index, item in
                        SegmentedControlButton(selected: index == selected, text: item.name) {
                            withAnimation {
                                selected = index
                            }
                        }
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                    .fill(Color.blue.opacity(0.1))
            )
        }
    }

    public var body: some View {
        VStack {
            tabButtons
            TabView(selection: $selected) {
                firstTab()
                    .tag(0)
                    .onTapGesture {
                        isViewInFocus = false
                    }
                secondTab()
                    .tag(1)
                    .onTapGesture {
                        isViewInFocus = false
                    }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarHidden(false)
        }
        .onChange(of: selected) { _ in
            isViewInFocus = false
        }
        .padding(.horizontal, 32)
        .padding(.top, 16)
    }

    public init(
        firstTab: Tab<Content1>,
        secondTab: Tab<Content2>,
        isViewInFocus: Binding<Bool> = .constant(false)
    ) {
        self.tabItems = [firstTab.tabItem, secondTab.tabItem]
        self.firstTab = firstTab.content
        self.secondTab = secondTab.content
        self._isViewInFocus = isViewInFocus
    }
}

#if DEBUG

struct AllwynSegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControl(
            firstTab: .init(tabItem: .init(name: "DRAW GAMES")) {
                VStack {
                    Text("123")
                    Text("123")
                    Text("123")
                }
            },
            secondTab: .init(tabItem: .init(name: "INSTANT GAMES")) {
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
