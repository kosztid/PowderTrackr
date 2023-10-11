// swiftlint:disable all
import Amplify
import Foundation

public struct Race: Model, Identifiable, Equatable {
  public let id: String
  public var name: String
  public var date: String
  public var shortestTime: Double
  public var shortestDistance: Double
  public var xCoords: [Double]?
  public var yCoords: [Double]?
  public var tracks: [TrackedPath]?
  public var participants: [String]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      date: String,
      shortestTime: Double,
      shortestDistance: Double,
      xCoords: [Double]? = nil,
      yCoords: [Double]? = nil,
      tracks: [TrackedPath]? = nil,
      participants: [String]? = nil) {
    self.init(id: id,
      name: name,
      date: date,
      shortestTime: shortestTime,
      shortestDistance: shortestDistance,
      xCoords: xCoords,
      yCoords: yCoords,
      tracks: tracks,
      participants: participants,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      date: String,
      shortestTime: Double,
      shortestDistance: Double,
      xCoords: [Double]? = nil,
      yCoords: [Double]? = nil,
      tracks: [TrackedPath]? = nil,
      participants: [String]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.date = date
      self.shortestTime = shortestTime
      self.shortestDistance = shortestDistance
      self.xCoords = xCoords
      self.yCoords = yCoords
      self.tracks = tracks
      self.participants = participants
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
