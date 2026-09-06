import SwiftUI

struct SettingsView: View {
	@Environment(AppRouter.self) private var router
	@State private var notificationMessage: String?
	@AppStorage(.enabledNotifications) private var notificationsEnabled: Bool = false

	var body: some View {
		Form {
			Section("Preferences") {
				Toggle("Notifications", isOn: $notificationsEnabled)
				if let notificationMessage {
					Text(notificationMessage)
						.font(.footnote)
						.foregroundStyle(.secondary)
				}
			}
			Section("Premium") {
				Button("Upgrade to Pro") {
					router.presentSheet(.paywall)
				}
				.foregroundStyle(.blue)
			}
			Section {
				Text("MyApp")
					.foregroundStyle(.secondary)
			}
		}
		.onChange(of: notificationsEnabled) { _, enabled in
			guard enabled else {
				Task {
					await NotificationService.shared.cancelAllNotifications()
				}
				return
			}

			Task {
				await NotificationService.shared.requestAuthorization { granted in
					Task { @MainActor in
						notificationMessage = granted ? "Notifications enabled" : "Allow notifications in Settings"
					}
				}
			}
		}
	}
}
