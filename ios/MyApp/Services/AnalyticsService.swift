import FirebaseAnalytics
import Foundation

extension AnalyticsService {
    enum Event: String {
        case appLaunch = "app_launch"
        case onboardingCompleted = "onboarding_completed"
        case profileViewed = "profile_viewed"
        case paywallDisplayed = "paywall_displayed"
        case screenView = "screen_view"
    }

    enum Parameter: String {
        case userID = "user_id"
        case screenName = "screen_name"
    }

    enum Screen: String {
        case onboarding = "Onboarding"
        case profile = "Profile"
        case paywall = "Paywall"
    }

    enum UserProperty: String {
        case userType = "user_type"
    }
    
}

struct AnalyticsService {
    static let shared = AnalyticsService()

    func trackEvent(_ event: Event, parameters: [Parameter: Any]? = nil) {
        logEvent(event, parameters: parameters)
    }

    func setUserProperty(_ property: UserProperty, value: String) {
        setFirebaseUserProperty(property, value: value)
    }

    func trackScreenView(_ screen: Screen) {
        logEvent(.screenView, parameters: [.screenName: screen.rawValue])
    }

    private func logEvent(_ event: Event, parameters: [Parameter: Any]? = nil) {
        var firebaseParameters: [String: Any] = [:]
        parameters?.forEach { key, value in
            firebaseParameters[key.rawValue] = value
        }
        Analytics.logEvent(event.rawValue, parameters: firebaseParameters)
        #if DEBUG
        AppLogger.analytics.debug("Logged event: \(event.rawValue, privacy: .public) with parameters: \(firebaseParameters, privacy: .public)")
        #endif
    }

    private func setFirebaseUserProperty(_ property: UserProperty, value: String) {
        Analytics.setUserProperty(value, forName: property.rawValue)
        #if DEBUG
        AppLogger.analytics.debug("Set user property: \(property.rawValue, privacy: .public) with value: \(value, privacy: .public)")
        #endif
    }
}