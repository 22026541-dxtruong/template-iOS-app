import SwiftUI

struct RootView: View {
    @AppStorage(.hasCompletedOnboarding) private var hasCompletedOnboarding: Bool = false

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
