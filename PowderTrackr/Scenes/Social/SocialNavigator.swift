import FlowStacks
import SwiftUI

public enum SocialScreen {
    case list
    case add(FriendAddView.InputModel)
    case requests
    case chat(PowderTrackrChatView.InputModel)
}

// sourcery: mock
protocol SocialListViewNavigatorProtocol {
    func navigateToRequest()
    func navigateToAdd(users: [User])
    func navigateToChat(model: PowderTrackrChatView.InputModel)
}

// sourcery: mock
protocol SocialAddViewNavigatorProtocol {
    func navigateBack()
}

// sourcery: mock
protocol SocialRequestsViewNavigatorProtocol {
}

public struct SocialNavigator: Navigator {
    @State var routes: Routes<SocialScreen>
    let openAccount: () -> Void

    public var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .list: ViewFactory.socialView(navigator: self, model: .init(navigateToAccount: openAccount))
            case .add(let model): ViewFactory.friendAddView(navigator: self, model: model)
            case .requests: ViewFactory.friendRequestView()
            case .chat(let model): ViewFactory.powderTrackrChatView(model: model)
            }
        }
    }

    public init(openAccount: @escaping () -> Void) {
        self.openAccount = openAccount
        self.routes = [.root(.list, embedInNavigationView: false)]
    }
}

extension SocialNavigator: SocialListViewNavigatorProtocol {
    func navigateToChat(model: PowderTrackrChatView.InputModel) {
        routes.push(.chat(model))
    }
    func navigateToRequest() {
        routes.push(.requests)
    }

    func navigateToAdd(users: [User]) {
        routes.presentSheet(.add(FriendAddView.InputModel(users: users)))
    }
}

extension SocialNavigator: SocialAddViewNavigatorProtocol {
    func navigateBack() {
        routes.dismiss()
    }
}
