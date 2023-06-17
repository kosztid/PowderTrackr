import SwiftUI

public class TrackedPathModel: Identifiable, Equatable, ObservableObject {
    public var id: String
    public var tracks: [TrackedPath]?

    fileprivate var _data: UserTrackedPaths?

    public var data: UserTrackedPaths? {
        if _data == nil {
            _data = UserTrackedPaths(
                id: self.id,
                tracks: self.tracks
            )
        }
        return _data
    }

    public static func == (lhs: TrackedPathModel, rhs: TrackedPathModel) -> Bool {
        lhs.id == rhs.id
    }

    public init(id: String, tracks: [TrackedPath]?) {
        self.id = id
        self.tracks = tracks
    }

    public convenience init(from data: UserTrackedPaths) {
        self.init(id: data.id, tracks: data.tracks)
        self._data = data
    }
}
