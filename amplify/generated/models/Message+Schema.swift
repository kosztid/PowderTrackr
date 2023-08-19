// swiftlint:disable all
import Amplify
import Foundation

extension Message {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case sender
    case date
    case text
    case isPhoto
    case isSeen
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let message = Message.keys
    
    model.pluralName = "Messages"
    
    model.fields(
      .field(message.id, is: .required, ofType: .string),
      .field(message.sender, is: .required, ofType: .string),
      .field(message.date, is: .required, ofType: .string),
      .field(message.text, is: .required, ofType: .string),
      .field(message.isPhoto, is: .required, ofType: .bool),
      .field(message.isSeen, is: .required, ofType: .bool)
    )
    }
}