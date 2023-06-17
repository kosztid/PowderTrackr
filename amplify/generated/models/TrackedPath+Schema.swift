// swiftlint:disable all
import Amplify
import Foundation

extension TrackedPath {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case startDate
    case endDate
    case notes
    case xCoords
    case yCoords
    case tracking
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let trackedPath = TrackedPath.keys
    
    model.pluralName = "TrackedPaths"
    
    model.fields(
      .field(trackedPath.id, is: .required, ofType: .string),
      .field(trackedPath.name, is: .required, ofType: .string),
      .field(trackedPath.startDate, is: .required, ofType: .string),
      .field(trackedPath.endDate, is: .required, ofType: .string),
      .field(trackedPath.notes, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(trackedPath.xCoords, is: .optional, ofType: .embeddedCollection(of: Double.self)),
      .field(trackedPath.yCoords, is: .optional, ofType: .embeddedCollection(of: Double.self)),
      .field(trackedPath.tracking, is: .required, ofType: .bool)
    )
    }
}