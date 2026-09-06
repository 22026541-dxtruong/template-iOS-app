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
        .overlay {
            if let dialog = router.presentedDialog {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            if case .customAlert = dialog {
                                router.dismissDialog()
                            }
                        }
                    
                    switch dialog {
                    case .networkError:
                        NetworkErrorDialog()
                    case .loading:
                        LoadingDialog()
                    case .customAlert(let title, let message):
                        CustomAlertDialog(title: title, message: message)
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .animation(.easeInOut(duration: 0.2), value: router.presentedDialog)
            }
        }
        .environment(router)
    }
}