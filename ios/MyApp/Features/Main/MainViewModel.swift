import SwiftUI
import Observation

@Observable
@MainActor
class MainViewModel {
    var isLoading = false
    var users: [User] = []

    private let userRepo: UserRepository

    init(_ userRepo: UserRepository = .shared) {
        self.userRepo = userRepo
    }
    
    func fetchUsers() async throws {
        isLoading = true
        users = try await userRepo.getAllUsers()
        isLoading = false
    }
}
