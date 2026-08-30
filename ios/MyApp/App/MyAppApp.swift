import SwiftUI
import SwiftData
import FirebaseCore

@main
struct MyAppApp : App {
    init() {
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
            LaunchView()
        }
    }
}

fileprivate struct LaunchView : View {
    @State private var container: ModelContainer?
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if let container {
                RootView()
                    .modelContainer(container)
            }
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .task {
            #if DEBUG
            let t0 = CFAbsoluteTimeGetCurrent()
            #endif

            async let minDelay: Void = Task.sleep(for: .milliseconds(700))

            let containerTask = Task.detached(priority: .userInitiated) { () -> ModelContainer in
                MyAppSchema.makeContainer()
            }

            container = await containerTask.value

            try? await minDelay

            #if DEBUG
            AppLogger.modelContext.info("LaunchView: container ready, elapsed: \(String(format: "%.3f", CFAbsoluteTimeGetCurrent() - t0)) seconds")
            #endif

            withAnimation(.easeInOut(duration: 0.3)) {
                showSplash = false
            }
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
