import Foundation
import FirebaseRemoteConfig
import FirebaseCore

struct RemoteConfigKeys {
    static let welcomeMessage = "welcome_message"
}

struct RemoteConfigDefaults {
    static let welcomeMessage = "Welcome to MyApp!"
}

actor RemoteConfigService {
    static let shared = RemoteConfigService()

    private let remoteConfig: RemoteConfig?

    private init() {
        if FirebaseCore.FirebaseApp.app() != nil {
            let rc = RemoteConfig.remoteConfig()
            let settings = RemoteConfigSettings()

            #if DEBUG
            settings.minimumFetchInterval = 0 // For development, fetch every time
            #else
            settings.minimumFetchInterval = 3600 // 1 hour
            #endif
            rc.configSettings = settings
            
            let defaults: [String: NSObject] = [
                RemoteConfigKeys.welcomeMessage: RemoteConfigDefaults.welcomeMessage as NSObject
            ]
            rc.setDefaults(defaults)
            remoteConfig = rc
        } else {
            remoteConfig = nil
        }
    }

    func fetchAndActivate() async throws {
        guard let remoteConfig = remoteConfig else { return }
        do {
            let status = try await remoteConfig.fetchAndActivate()
            AppLogger.remoteConfig.info("Remote config fetched and activated with status: \(status.rawValue)")
        } catch {
            AppLogger.remoteConfig.error("Failed to fetch and activate remote config with error: \(error.localizedDescription)")
        }
    }

    func string(forKey key: String) -> String {
        return remoteConfig?.configValue(forKey: key).stringValue ?? {
            if key == RemoteConfigKeys.welcomeMessage { return RemoteConfigDefaults.welcomeMessage }
            return ""
        }()
    }

    func bool(forKey key: String) -> Bool {
        return remoteConfig?.configValue(forKey: key).boolValue ?? false
    }

    func int(forKey key: String) -> Int {
        return remoteConfig?.configValue(forKey: key).numberValue.intValue ?? 0
    }

    func double(forKey key: String) -> Double {
        return remoteConfig?.configValue(forKey: key).numberValue.doubleValue ?? 0.0
    }

    func json(forKey key: String) -> [String: Any]? {
        guard let data = remoteConfig?.configValue(forKey: key).dataValue else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
}