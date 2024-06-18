public struct ToastModel: Equatable {
    public enum ToastType {
        case success
        case error
    }

    public let title: String
    public let type: ToastType

    public init(title: String, type: ToastType) {
        self.title = title
        self.type = type
    }
}
