// swiftlint:disable all
import Amplify
import Foundation

public struct UserTrackedPaths: Model {
  public let id: String
  public var tracks: [TrackedPath]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      tracks: [TrackedPath]? = nil) {
    self.init(id: id,
      tracks: tracks,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      tracks: [TrackedPath]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.tracks = tracks
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}