import Factory

public extension Container {
    static let accountService = Factory<AccountServiceProtocol>(scope: .shared) {
        AccountService()
    }
}
