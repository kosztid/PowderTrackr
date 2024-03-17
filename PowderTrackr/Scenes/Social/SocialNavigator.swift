import FlowStacks
import SwiftUI

public enum SocialScreen {
    case list
    case add
    case requests
    case chat(PowderTrackrChatView.InputModel)
}

protocol SocialListViewNavigatorProtocol {
    func navigateToRequest()
    func navigateToAdd()
    func navigateToChat(model: PowderTrackrChatView.InputModel)
}

protocol SocialAddViewNavigatorProtocol {
    func navigateBack()
}

protocol SocialRequestsViewNavigatorProtocol {
}

public struct SocialNavigator: Navigator {
    @State var routes: Routes<SocialScreen>
    let openAccount: () -> Void

    public var body: some View {
        Router($routes) { screen, _ in
            switch screen {
            case .list: ViewFactory.socialView(navigator: self, model: .init(navigateToAccount: openAccount))
            case .add: ViewFactory.friendAddView(navigator: self)
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

    func navigateToAdd() {
        routes.presentSheet(.add)
    }
}

extension SocialNavigator: SocialAddViewNavigatorProtocol {
    func navigateBack() {
        routes.dismiss()
    }
}
