import SwiftUI
import Observation

@Observable
class AppRouter {
    var selectedTab: AppTab = .home
    var navigationPath = NavigationPath()
    var presentedSheet: AppDestination?

    func navigate(to destination: AppDestination) {
        navigationPath.append(destination)
    }

    func presentSheet(_ destination: AppDestination) {
        presentedSheet = destination
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}