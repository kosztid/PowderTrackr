// swiftlint:disable all
import Amplify
import Foundation

extension UserTrackedPaths {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case tracks
    case sharedTracks
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userTrackedPaths = UserTrackedPaths.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "UserTrackedPaths"
    
    model.attributes(
      .primaryKey(fields: [userTrackedPaths.id])
    )
    
    model.fields(
      .field(userTrackedPaths.id, is: .required, ofType: .string),
      .field(userTrackedPaths.tracks, is: .optional, ofType: .embeddedCollection(of: TrackedPath.self)),
      .field(userTrackedPaths.sharedTracks, is: .optional, ofType: .embeddedCollection(of: TrackedPath.self)),
      .field(userTrackedPaths.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userTrackedPaths.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension UserTrackedPaths: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}