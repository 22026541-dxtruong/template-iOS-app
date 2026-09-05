import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    var isRefreshing = false
    var user: User?
    private let userRepo: UserRepository

    init(_ userRepo: UserRepository = .shared) {
        self.userRepo = userRepo
    }

    func refresh(id: UUID) async throws {
        AppLogger.app.info("HomeViewModel refresh started")
        isRefreshing = true
        user = try await userRepo.getUser(byID: id)
        isRefreshing = false
        AppLogger.app.info("HomeViewModel refresh finished")
    }
}
