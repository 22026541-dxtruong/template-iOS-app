import SwiftUI

struct AppFlow<Content: View>: View {
    @State private var router = AppRouter()
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            content()
                .navigationDestination(for: AppDestination.self) { dest in
                    switch dest {
                    case .onboarding:
                        OnboardingFlowView()
                    case .profile(let userID):
                        ProfileView(userID: userID)
                    case .paywall:
                        PaywallView()
                    }
                }
                .sheet(item: $router.presentedSheet) { destination in
                    switch destination {
                    case .paywall:
                        PaywallView()
                    case .onboarding:
                        OnboardingFlowView()
                    case .profile(let userID):
                        ProfileView(userID: userID)
                    }
                }
        }
        .environment(router)
    }
}