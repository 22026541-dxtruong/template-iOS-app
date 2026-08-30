import SwiftUI
import SwiftData

struct RootView : View {

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \User.name) private var users: [User]

    var body: some View {
        AppFlow {
            Group {
                if users.isEmpty {
                    OnboardingFlowView()
                } else {
                    MainView()
                }
            }
        }
    }
}
