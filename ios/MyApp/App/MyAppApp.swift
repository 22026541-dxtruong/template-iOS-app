import SwiftUI
import FirebaseCore

@main
struct MyAppApp: App {
    init() {
        setupDependencies()
    }

    private func setupDependencies() {
        _ = AppDatabase.shared
        FirebaseApp.configure()

        #if DEBUG
        BootClock.log("MyAppApp.init")
        #endif
    }

    @State private var isInitializing = true

    var body: some Scene {
        WindowGroup {
            if isInitializing {
                SplashView()
                    .task {
                        await performAsyncStartupTasks()
                        withAnimation {
                            isInitializing = false
                        }
                    }
            } else {
                RootView()
            }
        }
    }

    private func performAsyncStartupTasks() async {
        guard FirebaseApp.app() != nil else { return }
        AnalyticsService.shared.trackEvent(.appLaunch)
        await RemoteConfigService.shared.fetchAndActivate()
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
