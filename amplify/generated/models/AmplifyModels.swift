// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "dd0feb39f5222c5cd0205a48f0d4197e"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: CurrentPosition.self)
    ModelRegistry.register(modelType: UserfriendList.self)
    ModelRegistry.register(modelType: UserTrackedPaths.self)
    ModelRegistry.register(modelType: FriendRequest.self)
  }
}