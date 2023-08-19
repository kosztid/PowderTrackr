// swiftlint:disable all
import Amplify
import Foundation

extension PersonalChat {
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
    let personalChat = PersonalChat.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "PersonalChats"
    
    model.attributes(
      .primaryKey(fields: [personalChat.id])
    )
    
    model.fields(
      .field(personalChat.id, is: .required, ofType: .string),
      .field(personalChat.participants, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(personalChat.messages, is: .optional, ofType: .embeddedCollection(of: Message.self)),
      .field(personalChat.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(personalChat.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension PersonalChat: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}