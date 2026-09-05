import Foundation
import os

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.truongdx.myapp"

    static let app = Logger(subsystem: subsystem, category: "App")
    static let schema = Logger(subsystem: subsystem, category: "Schema")
    static let network = Logger(subsystem: subsystem, category: "Network")
    static let remoteConfig = Logger(subsystem: subsystem, category: "RemoteConfig")
    static let analytics = Logger(subsystem: subsystem, category: "Analytics")
    static let notification = Logger(subsystem: subsystem, category: "Notification")
    static let database = Logger(subsystem: subsystem, category: "Database")
}