import Foundation
import SwiftData

enum MyAppSchema {

    static let schema = Schema([User.self])

    static func makeContainer(inMemory: Bool = false) -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)

        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            #if DEBUG
            AppLogger.schema.error("Failed to create ModelContainer: \(error.localizedDescription); failing back to in-memory storage.")
            #endif
            let memoryConfig = ModelConfiguration(isStoredInMemoryOnly: true)
            return try! ModelContainer(for: schema, configurations: memoryConfig)
        }
    }
}