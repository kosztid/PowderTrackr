// swiftlint:disable all
import Amplify
import Foundation

extension GroupChat {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case participants
    case messages
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let groupChat = GroupChat.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "GroupChats"
    
    model.attributes(
      .primaryKey(fields: [groupChat.id])
    )
    
    model.fields(
      .field(groupChat.id, is: .required, ofType: .string),
      .field(groupChat.participants, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(groupChat.messages, is: .optional, ofType: .embeddedCollection(of: Message.self)),
      .field(groupChat.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(groupChat.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension GroupChat: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}