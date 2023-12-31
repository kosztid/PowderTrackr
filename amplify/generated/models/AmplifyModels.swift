// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "38a2f151b657eabeffde42080907bd05"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: CurrentPosition.self)
    ModelRegistry.register(modelType: UserfriendList.self)
    ModelRegistry.register(modelType: Race.self)
    ModelRegistry.register(modelType: UserTrackedPaths.self)
    ModelRegistry.register(modelType: FriendRequest.self)
    ModelRegistry.register(modelType: GroupChat.self)
    ModelRegistry.register(modelType: PersonalChat.self)
    ModelRegistry.register(modelType: LeaderBoard.self)
  }
}