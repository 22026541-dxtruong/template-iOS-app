import Foundation
import GRDB

struct UserRepository {
    private let dbWriter: any DatabaseWriter

    init(_ dbWriter: any DatabaseWriter) {
        self.dbWriter = dbWriter
    }

    func getUser(byID id: UUID) async throws -> User? {
        try await dbWriter.read { db in
            try User.getUser(byID: id).fetchOne(db)
        }
    }

    func getAllUsers() async throws -> [User] {
        try await dbWriter.read { db in
            try User.getAllUsers().fetchAll(db)
        }
    }

    func saveUser(_ user: User) async throws {
        try await dbWriter.write { db in
            try User.saveUser(user, in: db)
        }
    }
}

extension UserRepository {
    static let shared: UserRepository = {
        return UserRepository(AppDatabase.shared.dbWriter)
    }()
}