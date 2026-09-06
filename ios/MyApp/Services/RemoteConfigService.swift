import Foundation
import FirebaseRemoteConfig
import FirebaseCore

extension RemoteConfigService {
    
    enum Keys: String {
        case welcomeMessage = "welcome_message"
    }
    
    struct Defaults {
        static let welcomeMessage = "Welcome to MyApp!"
    }
}

struct RemoteConfigService: @unchecked Sendable{
    static let shared = RemoteConfigService()

    private let remoteConfig: RemoteConfig
    
    let defaults: [String: NSObject] = [
        Keys.welcomeMessage.rawValue: Defaults.welcomeMessage as NSObject
    ]

    private init() {
        let rc = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()

        #if DEBUG
        settings.minimumFetchInterval = 0 // For development, fetch every time
        #else
        settings.minimumFetchInterval = 3600 // 1 hour
        #endif
        rc.configSettings = settings
        
        rc.setDefaults(defaults)
        remoteConfig = rc
    }

    func fetchAndActivate() async {
        do {
            let status = try await remoteConfig.fetchAndActivate()
            AppLogger.remoteConfig.info("Remote config fetched and activated with status: \(status.rawValue)")
        } catch {
            AppLogger.remoteConfig.error("Failed to fetch and activate remote config with error: \(error.localizedDescription)")
        }
    }

    func string(forKey key: Keys) -> String {
        let value = remoteConfig.configValue(forKey: key.rawValue).stringValue
        if !value.isEmpty {
            return value
        }
        if key == .welcomeMessage { return Defaults.welcomeMessage }
        return ""
    }

    func bool(forKey key: Keys) -> Bool {
        return remoteConfig.configValue(forKey: key.rawValue).boolValue
    }

    func int(forKey key: Keys) -> Int {
        return remoteConfig.configValue(forKey: key.rawValue).numberValue.intValue
    }

    func double(forKey key: Keys) -> Double {
        return remoteConfig.configValue(forKey: key.rawValue).numberValue.doubleValue
    }

    func json(forKey key: Keys) -> [String: Any]? {
        let data = remoteConfig.configValue(forKey: key.rawValue).dataValue
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }
}
