// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Rsc {
  internal enum RaceManageItemView {
    internal enum Button {
      /// View my runs
      internal static let myRuns = Rsc.tr("Localizable", "RaceManageItemView.Button.MyRuns", fallback: "View my runs")
      /// Add participants
      internal static let share = Rsc.tr("Localizable", "RaceManageItemView.Button.Share", fallback: "Add participants")
    }
    internal enum Data {
      internal enum Distance {
        /// %@ meters
        internal static func description(_ p1: Any) -> String {
          return Rsc.tr("Localizable", "RaceManageItemView.Data.Distance.description", String(describing: p1), fallback: "%@ meters")
        }
        /// Shortest run:
        internal static let label = Rsc.tr("Localizable", "RaceManageItemView.Data.Distance.label", fallback: "Shortest run:")
      }
      internal enum Time {
        /// Best time:
        internal static let label = Rsc.tr("Localizable", "RaceManageItemView.Data.Time.label", fallback: "Best time:")
      }
    }
    internal enum Race {
      /// Race
      internal static let label = Rsc.tr("Localizable", "RaceManageItemView.Race.label", fallback: "Race")
    }
  }
  internal enum RaceRunView {
    internal enum Data {
      internal enum Distance {
        /// %@ meters
        internal static func description(_ p1: Any) -> String {
          return Rsc.tr("Localizable", "RaceRunView.Data.Distance.description", String(describing: p1), fallback: "%@ meters")
        }
        /// Distance:
        internal static let label = Rsc.tr("Localizable", "RaceRunView.Data.Distance.label", fallback: "Distance:")
      }
      internal enum Time {
        /// Time:
        internal static let label = Rsc.tr("Localizable", "RaceRunView.Data.Time.label", fallback: "Time:")
      }
    }
    internal enum Player {
      /// Player
      internal static let label = Rsc.tr("Localizable", "RaceRunView.Player.label", fallback: "Player")
      /// %@%
      internal static func percentage(_ p1: Any) -> String {
        return Rsc.tr("Localizable", "RaceRunView.Player.percentage", String(describing: p1), fallback: "%@%")
      }
      /// %@x
      internal static func speed(_ p1: Any) -> String {
        return Rsc.tr("Localizable", "RaceRunView.Player.speed", String(describing: p1), fallback: "%@x")
      }
    }
    internal enum Race {
      /// Race name
      internal static let label = Rsc.tr("Localizable", "RaceRunView.Race.label", fallback: "Race name")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Rsc {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
