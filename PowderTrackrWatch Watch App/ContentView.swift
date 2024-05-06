import SwiftUI

struct ContentView: View {
    let delegate = WatchSessionDelegate()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("\(delegate.started)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
