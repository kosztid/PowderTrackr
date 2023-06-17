// swiftlint:disable all
import Amplify
import Foundation

public struct CurrentPosition: Model {
  public let id: String
  public var name: String
  public var xCoord: String?
  public var yCoord: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      xCoord: String? = nil,
      yCoord: String? = nil) {
    self.init(id: id,
      name: name,
      xCoord: xCoord,
      yCoord: yCoord,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      xCoord: String? = nil,
      yCoord: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.xCoord = xCoord
      self.yCoord = yCoord
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}