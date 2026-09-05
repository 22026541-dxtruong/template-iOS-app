import SwiftUI
import FirebaseCore

@main
struct MyAppApp: App {
    init() {
        _ = AppDatabase.shared
        configureFirebaseIfAvailable()

        Task {
            guard FirebaseApp.app() != nil else { return }
            await AnalyticsService.shared.trackEvent(.appLaunch)
            try? await RemoteConfigService.shared.fetchAndActivate()
        }

        #if DEBUG
        BootClock.log("MyAppApp.init")
        #endif
    }

    private func configureFirebaseIfAvailable() {
        guard FirebaseApp.app() == nil,
              let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let values = NSDictionary(contentsOfFile: path),
              let projectID = values["PROJECT_ID"] as? String,
              !projectID.contains("replace-with") else {
            AppLogger.app.info("Firebase configuration not found; Firebase services are disabled.")
            return
        }

        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

#if DEBUG
enum BootClock {
    static let appLaunch = CFAbsoluteTimeGetCurrent()

    static func log(_ message: String) {
        let elapsed = CFAbsoluteTimeGetCurrent() - appLaunch
        AppLogger.app.info("BootClock: \(message), elapsed: \(String(format: "%.3f", elapsed)) seconds")
    }
}
#endif
