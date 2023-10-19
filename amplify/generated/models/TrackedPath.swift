// swiftlint:disable all
import Amplify
import Foundation

public struct TrackedPath: Embeddable, Identifiable, Equatable, Hashable {
  public var id: String
  var name: String
  var startDate: String
  var endDate: String
  var notes: [String]?
  var xCoords: [Double]?
  var yCoords: [Double]?
  var tracking: Bool
}
