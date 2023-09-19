import Factory

public extension Container {
    static let accountService = Factory<AccountServiceProtocol>(scope: .shared) {
        AccountService()
    }

    static let mapService = Factory<MapServiceProtocol>(scope: .shared) {
        MapService()
    }

    static let friendService = Factory<FriendServiceProtocol>(scope: .shared) {
        FriendService()
    }

    static let chatService = Factory<ChatServiceProtocol>(scope: .shared) {
        ChatService()
    }

    static let statisticsService = Factory<StatisticsServiceProtocol>(scope: .shared) {
        StatisticsService()
    }
}
