import Foundation
import Observation

@Observable
@MainActor
final class ProfileViewModel {
    var user: User?
    private let userRepo: UserRepository

    init(_ userRepo: UserRepository = .shared) {
        self.userRepo = userRepo
    }

    func refresh(id: UUID) async throws {
        AppLogger.app.info("ProfileViewModel refresh started")
        user = try await userRepo.getUser(byID: id)
        AppLogger.app.info("ProfileViewModel refresh finished")
    }
}
