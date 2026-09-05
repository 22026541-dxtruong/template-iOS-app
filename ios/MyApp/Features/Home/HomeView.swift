import Foundation
import SwiftUI

struct HomeView: View {
    let userId: UUID
    @State private var viewModel = HomeViewModel()
    @State private var welcomeMessage = "Hello"

    var body: some View {
        List {
            Section(welcomeMessage) {
                Text(viewModel.user?.name ?? "User")
                    .font(.title2.bold())
            }
            Section("Getting started") {
                Label("Your account is ready", systemImage: "checkmark.circle.fill")
                Label("Explore the app", systemImage: "sparkles")
            }
        }
        .listStyle(.insetGrouped)
        .task {
            do {
                try await viewModel.refresh(id: userId)
            } catch {
                AppLogger.app.error("Failed to refresh user: \(error.localizedDescription)")
            }
        }
        .onAppear {
            Task {
                let msg = await RemoteConfigService.shared.string(forKey: RemoteConfigKeys.welcomeMessage)
                if !msg.isEmpty {
                    welcomeMessage = msg
                }

                await NotificationService.shared.requestAuthorization { granted in
                    AppLogger.notification.info("Notification granted: \(granted)")
                }
            }
        }
    }
}
