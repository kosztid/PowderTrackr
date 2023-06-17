// swiftlint:disable all
import Amplify
import Foundation

public struct UserfriendList: Model {
  public let id: String
  public var friends: [Friend]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      friends: [Friend]? = nil) {
    self.init(id: id,
      friends: friends,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      friends: [Friend]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.friends = friends
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}