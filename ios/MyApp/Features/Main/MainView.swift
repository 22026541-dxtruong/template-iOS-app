import SwiftUI
import SwiftData

struct MainView: View {
	@Environment(AppRouter.self) private var router
	@Query(sort: \User.name) private var users: [User]

	var body: some View {
		TabView {
			HomeView()
				.tabItem { Label("Home", systemImage: "house") }
			SettingsView()
				.tabItem { Label("Settings", systemImage: "gearshape") }
		}
		.navigationTitle("MyApp")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					let id = users.first?.id ?? UUID()
					router.navigate(to: .profile(userID: id))
				} label: {
					Image(systemName: "person.crop.circle")
				}
			}
		}
	}
}
