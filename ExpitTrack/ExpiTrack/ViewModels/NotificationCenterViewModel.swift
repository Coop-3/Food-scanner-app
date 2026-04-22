// NotificationCenterViewModel.swift
//
// View model that converts inventory items into notification rows for the notifications screen.
// Added comments explain the purpose of the file and the role of important members.

import Foundation
import Combine

@MainActor
// NotificationCenterViewModel groups related state and behavior for this feature.
final class NotificationCenterViewModel: ObservableObject {
    // Notification rows displayed in the notifications screen.
    @Published private(set) var notifications: [AppNotification] = []

    // Reloads persisted data from local storage into memory.
    func reload(from items: [FoodItem]) {
        notifications = items.compactMap { item in
            // Derived status for the current food item being displayed.
            let status = FoodStatus.status(for: item.expirationDate)
            switch status {
            case .fresh:
                return nil
            case .expiringSoon:
                return AppNotification(
                    itemID: item.id,
                    itemName: item.name,
                    expirationDate: item.expirationDate,
                    message: "This item is expiring within 3 days.",
                    status: .expiringSoon
                )
            case .expired:
                return AppNotification(
                    itemID: item.id,
                    itemName: item.name,
                    expirationDate: item.expirationDate,
                    message: "This item has expired.",
                    status: .expired
                )
            }
        }
        .sorted { $0.expirationDate < $1.expirationDate }
    }
}
