// swiftlint:disable all
import Amplify
import Foundation

public struct FriendRequest: Model, Identifiable {
  public let id: String
  public var senderEmail: String
  public var sender: Friend
  public var recipient: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      senderEmail: String,
      sender: Friend,
      recipient: String) {
    self.init(id: id,
      senderEmail: senderEmail,
      sender: sender,
      recipient: recipient,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      senderEmail: String,
      sender: Friend,
      recipient: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.senderEmail = senderEmail
      self.sender = sender
      self.recipient = recipient
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}