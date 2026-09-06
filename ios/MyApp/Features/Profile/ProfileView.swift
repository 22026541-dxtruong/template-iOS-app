import SwiftUI

struct ProfileView: View {
    let userID: UUID
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        Form {
            LabeledContent("Name", value: viewModel.user?.name ?? "Loading...")
            LabeledContent("User ID", value: userID.uuidString)
        }
        .navigationTitle("Profile")
        .task {
            do {
                try await viewModel.refresh(id: userID)
            } catch {
                AppLogger.app.error("Failed to load profile user: \(error.localizedDescription)")
            }
        }
        .onAppear {
            AnalyticsService.shared.trackScreenView(.profile)
            AnalyticsService.shared.trackEvent(.profileViewed)
        }
    }
}
