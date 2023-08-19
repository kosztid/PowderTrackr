// swiftlint:disable all
import Amplify
import Foundation

public struct PersonalChat: Model {
  public let id: String
  public var participants: [String]?
  public var messages: [Message]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      participants: [String]? = nil,
      messages: [Message]? = nil) {
    self.init(id: id,
      participants: participants,
      messages: messages,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      participants: [String]? = nil,
      messages: [Message]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.participants = participants
      self.messages = messages
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}