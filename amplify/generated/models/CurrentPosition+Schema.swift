// swiftlint:disable all
import Amplify
import Foundation

extension CurrentPosition {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case xCoord
    case yCoord
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let currentPosition = CurrentPosition.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "CurrentPositions"
    
    model.attributes(
      .primaryKey(fields: [currentPosition.id])
    )
    
    model.fields(
      .field(currentPosition.id, is: .required, ofType: .string),
      .field(currentPosition.name, is: .required, ofType: .string),
      .field(currentPosition.xCoord, is: .optional, ofType: .string),
      .field(currentPosition.yCoord, is: .optional, ofType: .string),
      .field(currentPosition.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(currentPosition.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension CurrentPosition: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}