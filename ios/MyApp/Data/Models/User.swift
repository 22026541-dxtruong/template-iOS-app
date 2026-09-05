import Foundation
import GRDB
struct User: Codable, Identifiable, FetchableRecord, PersistableRecord {

    var id: UUID = UUID()
    var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

extension User {
    internal enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
    }

    static func createTable(in db: Database) throws {
        try db.create(table: databaseTableName) { t in
            t.column(Columns.id.name, .text).primaryKey()
            t.column(Columns.name.name, .text).notNull()
        }
    }

    static func getUser(byID id: UUID) throws -> QueryInterfaceRequest<User> {
        return User.filter(Columns.id == id)
    }

    static func getAllUsers() throws -> QueryInterfaceRequest<User> {
        return User.all()
    }

    static func saveUser(_ user: User,in db: Database) throws {
        try user.save(db)
    }
}
