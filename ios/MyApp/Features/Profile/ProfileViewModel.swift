import Foundation
import Observation
import SwiftData

@Observable
final class ProfileViewModel {
	var userName: String = "Unknown"

	func start(userID: UUID, using context: ModelContext) {
	}
}
