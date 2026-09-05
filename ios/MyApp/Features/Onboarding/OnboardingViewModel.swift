import Foundation
import Observation

@Observable
@MainActor
final class OnboardingViewModel {
    private let userRepo: UserRepository

    init(_ userRepo: UserRepository = .shared) {
        self.userRepo = userRepo
    }

    func saveUser(name: String) async throws {
        let savedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let user = User(name: savedName.isEmpty ? "Friend" : savedName)
        try await userRepo.saveUser(user)
    }
}
