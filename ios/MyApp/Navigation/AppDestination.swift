import Foundation

enum AppTab: Int, Hashable, CaseIterable {
    case home = 0
    case settings

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .settings:
            return "Settings"
        }
    }

    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .settings:
            return "gearshape"
        }
    }
}

enum AppDestination: Hashable, Identifiable {
    case onboarding
    case profile(userID: UUID)
    case paywall

    var id: String {
        switch self {
        case .onboarding:
            return "onboarding"
        case .profile(let userID):
            return "profile-\(userID)"
        case .paywall:
            return "paywall"
        }
    }
}