import Factory

public extension Container {
    static let dataService = Factory<DataService>(scope: .shared) {
        DataService()
    }
}
