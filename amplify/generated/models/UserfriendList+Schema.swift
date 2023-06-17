// swiftlint:disable all
import Amplify
import Foundation

extension UserfriendList {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case friends
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userfriendList = UserfriendList.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "UserfriendLists"
    
    model.attributes(
      .primaryKey(fields: [userfriendList.id])
    )
    
    model.fields(
      .field(userfriendList.id, is: .required, ofType: .string),
      .field(userfriendList.friends, is: .optional, ofType: .embeddedCollection(of: Friend.self)),
      .field(userfriendList.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userfriendList.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension UserfriendList: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}