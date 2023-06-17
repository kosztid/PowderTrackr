import SwiftUI

public class Friendlist: Identifiable, ObservableObject {
    public var id: String
    public var friends: [Friend]?

    fileprivate var _data: UserfriendList?

    public var data: UserfriendList? {
        if _data == nil {
            _data = UserfriendList(
                id: self.id,
                friends: self.friends
            )
        }
        return _data
    }

    public init(id: String, friends: [Friend]?) {
        self.id = id
        self.friends = friends
    }

    public convenience init(from data: UserfriendList) {
        self.init(id: data.id, friends: data.friends)
        self._data = data
    }
}
