import SwiftUI
import SwiftData

struct HomeView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var viewModel = HomeViewModel()
	@Query(sort: \User.name) private var users: [User]
	@State private var welcomeMessage = "Hello"

	var body: some View {
		List {
			Section(welcomeMessage) {
				Text(users.first?.name ?? viewModel.userName)
					.font(.title2.bold())
			}
			Section("Getting started") {
				Label("Your account is ready", systemImage: "checkmark.circle.fill")
				Label("Explore the app", systemImage: "sparkles")
			}
		}
		.listStyle(.insetGrouped)
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
