// swiftlint:disable all
import Amplify
import Foundation

extension Race {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case date
    case shortestTime
    case shortestDistance
    case xCoords
    case yCoords
    case tracks
    case participants
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let race = Race.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Races"
    
    model.attributes(
      .primaryKey(fields: [race.id])
    )
    
    model.fields(
      .field(race.id, is: .required, ofType: .string),
      .field(race.name, is: .required, ofType: .string),
      .field(race.date, is: .required, ofType: .string),
      .field(race.shortestTime, is: .required, ofType: .double),
      .field(race.shortestDistance, is: .required, ofType: .double),
      .field(race.xCoords, is: .optional, ofType: .embeddedCollection(of: Double.self)),
      .field(race.yCoords, is: .optional, ofType: .embeddedCollection(of: Double.self)),
      .field(race.tracks, is: .optional, ofType: .embeddedCollection(of: TrackedPath.self)),
      .field(race.participants, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(race.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(race.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Race: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}