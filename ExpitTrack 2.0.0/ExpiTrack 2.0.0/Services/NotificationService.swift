// NotificationService.swift
//
// Service that requests notification permission and schedules local notifications for expiring or expired items.
// Added comments explain the purpose of the file and the role of important members.

import Foundation
import UserNotifications

// NotificationService groups related state and behavior for this feature.
final class NotificationService {
    static let shared = NotificationService()

    private init() { }

    // Asks the user for notification permission.
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    // Schedules local notifications for items that are expiring soon or already expired.
    func scheduleNotifications(for items: [FoodItem]) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        for item in items {
            // Derived status for the current food item being displayed.
            let status = FoodStatus.status(for: item.expirationDate)

            guard status == .expiringSoon || status == .expired else { continue }

            let content = UNMutableNotificationContent()
            content.title = status == .expired ? "Item expired" : "Item expiring soon"
            content.body = "\(item.name) is \(status == .expired ? "expired" : "within 3 days of expiration")."
            content.sound = .default

            let triggerDate = DateComponents(
                year: Calendar.current.component(.year, from: Date()),
                month: Calendar.current.component(.month, from: Date()),
                day: Calendar.current.component(.day, from: Date()),
                hour: 9,
                minute: 0
            )

            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(
                identifier: item.id.uuidString,
                content: content,
                trigger: trigger
            )

            center.add(request)
        }
    }
}
