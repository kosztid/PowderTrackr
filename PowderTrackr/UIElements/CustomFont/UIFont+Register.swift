import UIKit

private final class BundleToken {}

public extension UIFont {
    static let heavyFontName = "Effra-Bold"
    static let lightFontName = "Effra-Light"
    static let boldFontName = "Effra-Bold"
    static let regularFontName = "Effra-Regular"
    private static let fontExtension = "ttf"

    static func registerFonts() {
        UIFont.registerFont(with: heavyFontName, fileExtension: fontExtension)
        UIFont.registerFont(with: lightFontName, fileExtension: fontExtension)
        UIFont.registerFont(with: boldFontName, fileExtension: fontExtension)
        UIFont.registerFont(with: regularFontName, fileExtension: fontExtension)
    }
}

/// https://stackoverflow.com/questions/30507905/xcode-using-custom-fonts-inside-dynamic-framework/32600784#comment101568381_32600784
extension UIFont {
    static var bundle: Bundle {
        Bundle(for: BundleToken.self)
    }

    static func registerFont(with name: String, fileExtension: String) {
        let errorMessage = "Failed to register font: \(name).\(fileExtension)."

        guard let url = bundle.url(forResource: name, withExtension: fileExtension) else {
            fatalError("\(errorMessage) Resource was not found in bundle.")
        }

        var errorRef: Unmanaged<CFError>?
        if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &errorRef) == false {
            print("\(errorMessage) Reason: \(errorRef?.takeUnretainedValue().localizedDescription ?? "Unknown")")
        }
    }
}
