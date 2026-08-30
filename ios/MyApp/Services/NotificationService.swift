import Foundation
import UserNotifications

struct NotificationConfig: Codable {

    let delay: [DelayNotification]
    let daily: [DailyNotification]

    init(delay: [DelayNotification], daily: [DailyNotification]) {
        self.delay = delay
        self.daily = daily
    }
}

struct DelayNotification: Codable {
    let id: String
    let title: String
    let body: String
    let delayMinutes: Int
    let active: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case delayMinutes = "delay_minutes"
        case active
    }

    init(id: String, title: String, body: String, delayMinutes: Int, active: Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.delayMinutes = delayMinutes
        self.active = active
    }
}

struct DailyNotification: Codable {
    let id: String
    let title: String
    let body: String
    let timeOfDay: String
    let daysOfWeek: [String]
    let active: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case body
        case timeOfDay = "time_of_day"
        case daysOfWeek = "days_of_week"
        case active
    }

    init(id: String, title: String, body: String, timeOfDay: String, daysOfWeek: [String], active: Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.timeOfDay = timeOfDay
        self.daysOfWeek = daysOfWeek
        self.active = active
    }
}

actor NotificationService {

    static let shared = NotificationService()

    private init() {}

    func requestAuthorization(completion: @escaping @Sendable (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { granted, error in
            if let error = error {
                AppLogger.notification.error("Error requesting notification authorization: \(error.localizedDescription)")
            }
            completion(granted)
        }
    }

    func scheduleDelayNotification(id: String, title: String, body: String, timeInterval: TimeInterval, repeats: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                AppLogger.notification.error("Error scheduling notification \(id): \(error.localizedDescription)")
            } else {
                AppLogger.notification.info("Scheduled notification \(id) with title: \(title)")
            }
        }
    }

    func scheduleDailyNotification(id: String, title: String, body: String, hour: Int, minute: Int, daysOfWeek: [Int]) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        for day in daysOfWeek {
            var dateComponents = DateComponents()
            dateComponents.weekday = day
            dateComponents.hour = hour
            dateComponents.minute = minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(id)_\(day)", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        AppLogger.notification.error("Error scheduling daily notification \(id) for day \(day): \(error.localizedDescription)")
                } else {
                        AppLogger.notification.info("Scheduled daily notification \(id) for day \(day) with title: \(title)")
                }
            }
        }
    }

    func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        AppLogger.notification.info("Cancelled notification \(id)")
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        AppLogger.notification.info("Cancelled all pending notifications")
    }
}
