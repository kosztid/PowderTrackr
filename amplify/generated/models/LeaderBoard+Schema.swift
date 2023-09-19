// swiftlint:disable all
import Amplify
import Foundation

extension LeaderBoard {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case distance
    case totalTimeInSeconds
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let leaderBoard = LeaderBoard.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "LeaderBoards"
    
    model.attributes(
      .primaryKey(fields: [leaderBoard.id])
    )
    
    model.fields(
      .field(leaderBoard.id, is: .required, ofType: .string),
      .field(leaderBoard.name, is: .required, ofType: .string),
      .field(leaderBoard.distance, is: .required, ofType: .double),
      .field(leaderBoard.totalTimeInSeconds, is: .required, ofType: .double),
      .field(leaderBoard.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(leaderBoard.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension LeaderBoard: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}