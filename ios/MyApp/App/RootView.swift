import SwiftUI

struct RootView: View {
    @AppStorage(AppStorageKeys.hasCompletedOnboarding) private var hasCompletedOnboarding: Bool = false

    var body: some View {
        AppFlow {
            Group {
                if hasCompletedOnboarding == false {
                    OnboardingFlowView()
                } else {
                    MainView()
                }
            }
        }
    }
}
