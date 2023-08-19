// swiftlint:disable all
import Amplify
import Foundation

public struct Message: Embeddable {
  var id: String
  var sender: String
  var date: String
  var text: String
  var isPhoto: Bool
  var isSeen: Bool
}