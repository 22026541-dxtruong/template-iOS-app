import SwiftUI
import SwiftData

struct ProfileView: View {
	let userID: UUID
	@Environment(\.modelContext) private var modelContext
	@State private var viewModel = ProfileViewModel()
	@Query private var users: [User]

	init(userID: UUID) {
		self.userID = userID
		let id = userID
		self._users = Query(filter: #Predicate<User> { $0.id == id })
	}

	var body: some View {
		Form {
			LabeledContent("Name", value: users.first?.name ?? viewModel.userName)
			LabeledContent("User ID", value: userID.uuidString)
		}
		.navigationTitle("Profile")
		.onAppear {
			Task {
				await AnalyticsService.shared.trackScreenView(.profile)
				await AnalyticsService.shared.trackEvent(.profileViewed)
			}
		}
	}
}
