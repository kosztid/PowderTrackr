// swiftlint:disable all
import Amplify
import Foundation

extension Friend {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case isTracking
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let friend = Friend.keys
    
    model.pluralName = "Friends"
    
    model.fields(
      .field(friend.id, is: .required, ofType: .string),
      .field(friend.name, is: .required, ofType: .string),
      .field(friend.isTracking, is: .required, ofType: .bool)
    )
    }
}