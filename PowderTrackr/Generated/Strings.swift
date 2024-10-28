// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Rsc {
  internal enum ChangePasswordView {
    internal enum Button {
      /// Update
      internal static let update = Rsc.tr("Localizable", "ChangePasswordView.Button.Update", fallback: "Update")
    }
    internal enum Header {
      /// Update Password
      internal static let description = Rsc.tr("Localizable", "ChangePasswordView.Header.Description", fallback: "Update Password")
    }
    internal enum Password {
      /// Please type in your old and new password to change it.
      internal static let description = Rsc.tr("Localizable", "ChangePasswordView.Password.Description", fallback: "Please type in your old and new password to change it.")
      /// New Password
      internal static let new = Rsc.tr("Localizable", "ChangePasswordView.Password.New", fallback: "New Password")
      /// Old Password
      internal static let old = Rsc.tr("Localizable", "ChangePasswordView.Password.Old", fallback: "Old Password")
    }
  }
  internal enum ConfirmResetPasswordView {
    /// Verification Code
    internal static let code = Rsc.tr("Localizable", "ConfirmResetPasswordView.Code", fallback: "Verification Code")
    /// Password
    internal static let password = Rsc.tr("Localizable", "ConfirmResetPasswordView.Password", fallback: "Password")
    /// Username
    internal static let username = Rsc.tr("Localizable", "ConfirmResetPasswordView.Username", fallback: "Username")
    internal enum Button {
      /// Verify
      internal static let verify = Rsc.tr("Localizable", "ConfirmResetPasswordView.Button.Verify", fallback: "Verify")
    }
    internal enum Header {
      /// Verification
      internal static let description = Rsc.tr("Localizable", "ConfirmResetPasswordView.Header.Description", fallback: "Verification")
    }
    internal enum Username {
      /// Please enter the verification code from the password reset email to reset password for user: %@
      internal static func description(_ p1: Any) -> String {
        return Rsc.tr("Localizable", "ConfirmResetPasswordView.Username.Description", String(describing: p1), fallback: "Please enter the verification code from the password reset email to reset password for user: %@")
      }
    }
  }
  internal enum FriendAddView {
    internal enum EmptyList {
      /// You have no users to add
      internal static let description = Rsc.tr("Localizable", "FriendAddView.EmptyList.Description", fallback: "You have no users to add")
    }
    internal enum Header {
      /// Add friends to ski with
      internal static let title = Rsc.tr("Localizable", "FriendAddView.Header.Title", fallback: "Add friends to ski with")
    }
    internal enum SearchBar {
      /// Search...
      internal static let label = Rsc.tr("Localizable", "FriendAddView.SearchBar.Label", fallback: "Search...")
    }
  }
  internal enum FriendListItem {
    internal enum LastMessage {
      /// ...
      internal static let received = Rsc.tr("Localizable", "FriendListItem.LastMessage.Received", fallback: "...")
      /// You: %@
      internal static func sent(_ p1: Any) -> String {
        return Rsc.tr("Localizable", "FriendListItem.LastMessage.Sent", String(describing: p1), fallback: "You: %@")
      }
    }
  }
  internal enum HeaderView {
    internal enum Title {
      /// Welcome to PowderTrackr
      internal static let `default` = Rsc.tr("Localizable", "HeaderView.Title.default", fallback: "Welcome to PowderTrackr")
    }
  }
  internal enum LeaderBoardView {
    internal enum Data {
      internal enum Distance {
        /// Distance
        internal static let label = Rsc.tr("Localizable", "LeaderBoardView.Data.Distance.label", fallback: "Distance")
      }
      internal enum Time {
        /// Time
        internal static let label = Rsc.tr("Localizable", "LeaderBoardView.Data.Time.label", fallback: "Time")
      }
    }
    internal enum Row {
      internal enum Distance {
        /// %@ km
        internal static func label(_ p1: Any) -> String {
          return Rsc.tr("Localizable", "LeaderBoardView.Row.Distance.label", String(describing: p1), fallback: "%@ km")
        }
      }
      internal enum Time {
        /// %@ min
        internal static func label(_ p1: Any) -> String {
          return Rsc.tr("Localizable", "LeaderBoardView.Row.Time.label", String(describing: p1), fallback: "%@ min")
        }
      }
    }
  }
  internal enum LoginView {
    /// Password
    internal static let password = Rsc.tr("Localizable", "LoginView.Password", fallback: "Password")
    /// Username
    internal static let username = Rsc.tr("Localizable", "LoginView.Username", fallback: "Username")
    internal enum Button {
      /// Forgotten Password
      internal static let forgottenPassword = Rsc.tr("Localizable", "LoginView.Button.ForgottenPassword", fallback: "Forgotten Password")
      /// Login
      internal static let login = Rsc.tr("Localizable", "LoginView.Button.Login", fallback: "Login")
    }
    internal enum Error {
      /// Failed to log in please check your credentials
      internal static let description = Rsc.tr("Localizable", "LoginView.Error.Description", fallback: "Failed to log in please check your credentials")
      /// Please check your credentials
      internal static let subDescription = Rsc.tr("Localizable", "LoginView.Error.SubDescription", fallback: "Please check your credentials")
    }
    internal enum Header {
      /// Login
      internal static let description = Rsc.tr("Localizable", "LoginView.Header.Description", fallback: "Login")
    }
    internal enum Login {
      /// Please enter your credentials
      internal static let description = Rsc.tr("Localizable", "LoginView.Login.Description", fallback: "Please enter your credentials")
    }
  }
  internal enum PowderTrackrChatView {
    internal enum NewMessage {
      /// Write your message
      internal static let label = Rsc.tr("Localizable", "PowderTrackrChatView.NewMessage.Label", fallback: "Write your message")
    }
    internal enum Sender {
      /// Me
      internal static let outgoing = Rsc.tr("Localizable", "PowderTrackrChatView.Sender.Outgoing", fallback: "Me")
    }
  }
  internal enum ProfileView {
    internal enum Button {
      /// Login
      internal static let login = Rsc.tr("Localizable", "ProfileView.Button.Login", fallback: "Login")
      /// Logout
      internal static let logout = Rsc.tr("Localizable", "ProfileView.Button.Logout", fallback: "Logout")
      /// Register
      internal static let register = Rsc.tr("Localizable", "ProfileView.Button.Register", fallback: "Register")
      /// Update password
      internal static let updatePassword = Rsc.tr("Localizable", "ProfileView.Button.UpdatePassword", fallback: "Update password")
    }
    internal enum Data {
      /// Email address
      internal static let email = Rsc.tr("Localizable", "ProfileView.Data.Email", fallback: "Email address")
      /// Name
      internal static let name = Rsc.tr("Localizable", "ProfileView.Data.Name", fallback: "Name")
      /// You
      internal static let you = Rsc.tr("Localizable", "ProfileView.Data.You", fallback: "You")
    }
    internal enum Header {
      /// To track your snowy adventures
      internal static let description = Rsc.tr("Localizable", "ProfileView.Header.Description", fallback: "To track your snowy adventures")
      internal enum Profile {
        /// Profile
        internal static let title = Rsc.tr("Localizable", "ProfileView.Header.Profile.Title", fallback: "Profile")
      }
    }
    internal enum LoggedOut {
      /// Please login or create an account to continue
      internal static let description = Rsc.tr("Localizable", "ProfileView.LoggedOut.Description", fallback: "Please login or create an account to continue")
      /// Select an option to continue
      internal static let title = Rsc.tr("Localizable", "ProfileView.LoggedOut.Title", fallback: "Select an option to continue")
    }
    internal enum Stats {
      /// Stats
      internal static let label = Rsc.tr("Localizable", "ProfileView.Stats.Label", fallback: "Stats")
      internal enum Distance {
        /// %@ km
        internal static func description(_ p1: Any) -> String {
          return Rsc.tr("Localizable", "ProfileView.Stats.Distance.Description", String(describing: p1), fallback: "%@ km")
        }
        /// Total distance on snow:
        internal static let label = Rsc.tr("Localizable", "ProfileView.Stats.Distance.Label", fallback: "Total distance on snow:")
      }
      internal enum Time {
        /// Total time on snow:
        internal static let label = Rsc.tr("Localizable", "ProfileView.Stats.Time.Label", fallback: "Total time on snow:")
      }
    }
    internal enum Verify {
      /// Please verify your email address by entering the verification code from the confirmation email.
      internal static let description = Rsc.tr("Localizable", "ProfileView.Verify.Description", fallback: "Please verify your email address by entering the verification code from the confirmation email.")
    }
  }
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
  internal enum RacesView {
    internal enum Alert {
      /// Are you sure want to delete this race?
      internal static let message = Rsc.tr("Localizable", "RacesView.Alert.Message", fallback: "Are you sure want to delete this race?")
      internal enum Button {
        /// Cancel
        internal static let cancel = Rsc.tr("Localizable", "RacesView.Alert.Button.Cancel", fallback: "Cancel")
        /// Delete
        internal static let delete = Rsc.tr("Localizable", "RacesView.Alert.Button.Delete", fallback: "Delete")
      }
    }
    internal enum NoRaces {
      /// You have no races so far...
      internal static let label = Rsc.tr("Localizable", "RacesView.NoRaces.Label", fallback: "You have no races so far...")
    }
  }
  internal enum RegisterView {
    /// Email
    internal static let email = Rsc.tr("Localizable", "RegisterView.Email", fallback: "Email")
    /// Password
    internal static let password = Rsc.tr("Localizable", "RegisterView.Password", fallback: "Password")
    /// Username
    internal static let username = Rsc.tr("Localizable", "RegisterView.Username", fallback: "Username")
    internal enum Button {
      /// Register
      internal static let register = Rsc.tr("Localizable", "RegisterView.Button.Register", fallback: "Register")
    }
    internal enum Header {
      /// Register
      internal static let description = Rsc.tr("Localizable", "RegisterView.Header.Description", fallback: "Register")
    }
    internal enum Register {
      /// Please fill the fields to create an account
      internal static let description = Rsc.tr("Localizable", "RegisterView.Register.Description", fallback: "Please fill the fields to create an account")
    }
  }
  internal enum ResetPasswordView {
    /// Username
    internal static let username = Rsc.tr("Localizable", "ResetPasswordView.Username", fallback: "Username")
    internal enum Button {
      /// Reset
      internal static let reset = Rsc.tr("Localizable", "ResetPasswordView.Button.Reset", fallback: "Reset")
    }
    internal enum Header {
      /// Password Reset
      internal static let description = Rsc.tr("Localizable", "ResetPasswordView.Header.Description", fallback: "Password Reset")
    }
    internal enum Username {
      /// Please type in your username to reset your password.
      internal static let description = Rsc.tr("Localizable", "ResetPasswordView.Username.Description", fallback: "Please type in your username to reset your password.")
    }
  }
  internal enum ShareListView {
    /// You have no friends to share with
    internal static let emptyList = Rsc.tr("Localizable", "ShareListView.EmptyList", fallback: "You have no friends to share with")
    internal enum Button {
      /// Share
      internal static let share = Rsc.tr("Localizable", "ShareListView.Button.Share", fallback: "Share")
    }
  }
  internal enum SocialView {
    internal enum Infocard {
      /// Requests
      internal static let buttonTitle = Rsc.tr("Localizable", "SocialView.Infocard.ButtonTitle", fallback: "Requests")
      /// You have a new friendrequest(s)
      internal static let message = Rsc.tr("Localizable", "SocialView.Infocard.Message", fallback: "You have a new friendrequest(s)")
    }
    internal enum SwipeToDelete {
      /// Delete
      internal static let label = Rsc.tr("Localizable", "SocialView.SwipeToDelete.Label", fallback: "Delete")
    }
  }
  internal enum TrackListItem {
    internal enum Alert {
      internal enum Delete {
        /// Yes
        internal static let button = Rsc.tr("Localizable", "TrackListItem.Alert.Delete.Button", fallback: "Yes")
        /// Cancel
        internal static let cancelButton = Rsc.tr("Localizable", "TrackListItem.Alert.Delete.CancelButton", fallback: "Cancel")
        /// Are you sure to delete?
        internal static let title = Rsc.tr("Localizable", "TrackListItem.Alert.Delete.Title", fallback: "Are you sure to delete?")
      }
      internal enum Note {
        /// Add
        internal static let button = Rsc.tr("Localizable", "TrackListItem.Alert.Note.Button", fallback: "Add")
        /// Cancel
        internal static let cancelButton = Rsc.tr("Localizable", "TrackListItem.Alert.Note.CancelButton", fallback: "Cancel")
        /// Enter note description
        internal static let textField = Rsc.tr("Localizable", "TrackListItem.Alert.Note.TextField", fallback: "Enter note description")
        /// Add Note
        internal static let title = Rsc.tr("Localizable", "TrackListItem.Alert.Note.Title", fallback: "Add Note")
      }
      internal enum Rename {
        /// Rename
        internal static let button = Rsc.tr("Localizable", "TrackListItem.Alert.Rename.Button", fallback: "Rename")
        /// Cancel
        internal static let cancelButton = Rsc.tr("Localizable", "TrackListItem.Alert.Rename.CancelButton", fallback: "Cancel")
        /// Enter the new name...
        internal static let textField = Rsc.tr("Localizable", "TrackListItem.Alert.Rename.TextField", fallback: "Enter the new name...")
        /// Rename run...
        internal static let title = Rsc.tr("Localizable", "TrackListItem.Alert.Rename.Title", fallback: "Rename run...")
      }
    }
    internal enum Header {
      /// Date
      internal static let date = Rsc.tr("Localizable", "TrackListItem.Header.Date", fallback: "Date")
    }
  }
  internal enum TrackListView {
    internal enum List {
      internal enum Normal {
        /// You have no tracks recorded
        internal static let empty = Rsc.tr("Localizable", "TrackListView.List.Normal.Empty", fallback: "You have no tracks recorded")
      }
      internal enum Shared {
        /// You have no tracks shared with you
        internal static let empty = Rsc.tr("Localizable", "TrackListView.List.Shared.Empty", fallback: "You have no tracks shared with you")
      }
    }
    internal enum Tabs {
      /// Normal
      internal static let normal = Rsc.tr("Localizable", "TrackListView.Tabs.Normal", fallback: "Normal")
      /// Shared
      internal static let shared = Rsc.tr("Localizable", "TrackListView.Tabs.Shared", fallback: "Shared")
    }
  }
  internal enum VerifyView {
    /// Verification Code
    internal static let code = Rsc.tr("Localizable", "VerifyView.Code", fallback: "Verification Code")
    internal enum Button {
      /// Verify
      internal static let verify = Rsc.tr("Localizable", "VerifyView.Button.Verify", fallback: "Verify")
    }
    internal enum Header {
      /// Verification
      internal static let description = Rsc.tr("Localizable", "VerifyView.Header.Description", fallback: "Verification")
    }
    internal enum Verify {
      /// Please verify your email address by entering the verification code from the confirmation email.
      internal static let description = Rsc.tr("Localizable", "VerifyView.Verify.Description", fallback: "Please verify your email address by entering the verification code from the confirmation email.")
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
