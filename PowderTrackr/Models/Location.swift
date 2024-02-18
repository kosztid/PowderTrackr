import SwiftUI

public class Location: Identifiable, ObservableObject {
    public var id: String
    public var name: String
    public var xCoord: String?
    public var yCoord: String?

    fileprivate var _data: CurrentPosition?

    public var data: CurrentPosition? {
        if _data == nil {
            _data = CurrentPosition(
                id: self.id,
                name: self.name,
                xCoord: self.xCoord ?? "",
                yCoord: self.yCoord ?? ""
            )
        }
        return _data
    }

    public init(id: String, name: String, xCoord: String? = nil, yCoord: String? = nil ) {
        self.id = id
        self.name = name
        self.xCoord = xCoord
        self.yCoord = yCoord
    }

    public convenience init(from data: CurrentPosition) {
        self.init(id: data.id, name: data.name, xCoord: data.xCoord, yCoord: data.yCoord)
        self._data = data
    }
}
