import Foundation
import Observation
import SwiftData

@Observable
final class HomeViewModel {
	var isRefreshing = false
	var userName: String = "Friend"

	func start(using context: ModelContext) {
	}

	func refresh() async {
		AppLogger.app.info("HomeViewModel refresh started")
		isRefreshing = true
		try? await Task.sleep(for: .milliseconds(250))
		isRefreshing = false
		AppLogger.app.info("HomeViewModel refresh finished")
	}
}
