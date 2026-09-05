import Foundation
import GRDB

struct AppDatabase {
    let dbWriter: any DatabaseWriter

    init(_ writer: DatabaseWriter) throws {
        self.dbWriter = writer
        try Self.migrator.migrate(dbWriter)
    }
}

extension AppDatabase {
    
    static let shared: AppDatabase = {
        do {
            let dbURL = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("db.sqlite")

            var config = Configuration()
            config.prepareDatabase { db in
                #if DEBUG
                db.trace { print($0) }
                #endif
            }

            let dbPool = try DatabasePool(path: dbURL.path, configuration: config)
            return try AppDatabase(dbPool)
        } catch {
            AppLogger.app.error("Failed to initialize database: \(error.localizedDescription)")
            fatalError("Unresolved error \(error)")
        }
    }()

    static let empty: AppDatabase = {
        do {
            let dbQueue = try DatabaseQueue(configuration: Configuration())
            return try AppDatabase(dbQueue)
        } catch {
            AppLogger.app.error("Failed to initialize empty database: \(error.localizedDescription)")
            fatalError("Unresolved error \(error)")
        }
    }()
}