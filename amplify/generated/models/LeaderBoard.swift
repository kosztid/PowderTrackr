// swiftlint:disable all
import Amplify
import Foundation

public struct LeaderBoard: Model {
  public let id: String
  public var name: String
  public var distance: Double
  public var totalTimeInSeconds: Double
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      distance: Double,
      totalTimeInSeconds: Double) {
    self.init(id: id,
      name: name,
      distance: distance,
      totalTimeInSeconds: totalTimeInSeconds,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      distance: Double,
      totalTimeInSeconds: Double,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.distance = distance
      self.totalTimeInSeconds = totalTimeInSeconds
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}