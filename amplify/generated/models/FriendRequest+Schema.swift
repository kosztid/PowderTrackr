// swiftlint:disable all
import Amplify
import Foundation

extension FriendRequest {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case senderEmail
    case sender
    case recipient
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let friendRequest = FriendRequest.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "FriendRequests"
    
    model.attributes(
      .primaryKey(fields: [friendRequest.id])
    )
    
    model.fields(
      .field(friendRequest.id, is: .required, ofType: .string),
      .field(friendRequest.senderEmail, is: .required, ofType: .string),
      .field(friendRequest.sender, is: .required, ofType: .embedded(type: Friend.self)),
      .field(friendRequest.recipient, is: .required, ofType: .string),
      .field(friendRequest.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(friendRequest.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension FriendRequest: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}