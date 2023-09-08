// swiftlint:disable all
import Amplify
import Foundation

public struct UserTrackedPaths: Model {
  public let id: String
  public var tracks: [TrackedPath]?
  public var sharedTracks: [TrackedPath]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      tracks: [TrackedPath]? = nil,
      sharedTracks: [TrackedPath]? = nil) {
    self.init(id: id,
      tracks: tracks,
      sharedTracks: sharedTracks,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      tracks: [TrackedPath]? = nil,
      sharedTracks: [TrackedPath]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.tracks = tracks
      self.sharedTracks = sharedTracks
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}