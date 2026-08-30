import Foundation
import SwiftData
import Observation

@Observable
final class OnboardingViewModel {
	var name = ""
	private var modelContext: ModelContext?

	func start(using context: ModelContext) {
		modelContext = context
	}

	func finish() {
		guard let modelContext else { return }
		let user = User(name: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Friend" : name)
		modelContext.insert(user)
		try? modelContext.save()
	}
}
