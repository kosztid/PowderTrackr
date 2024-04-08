import SwiftUI

private struct CustomFontProviderKey: EnvironmentKey {
    static var defaultValue = CustomFontProvider()
}

public extension EnvironmentValues {
    var customFontProvider: CustomFontProvider {
        get { self[CustomFontProviderKey.self] }
        set { self[CustomFontProviderKey.self] = newValue }
    }
}

public extension View {
    /// Set the customFontProvider environment property
    /// - Parameter customFontProvider: A CustomFont to use
    func customFontProvider(_ customFontProvider: CustomFontProvider) -> some View {
        environment(\.customFontProvider, customFontProvider)
    }
}
