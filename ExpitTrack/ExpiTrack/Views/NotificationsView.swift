// NotificationsView.swift
//
// Screen that lists expired and expiring-soon notifications generated from the inventory.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// NotificationsView groups related state and behavior for this feature.
struct NotificationsView: View {
    // Shared notifications state derived from inventory items.
    @EnvironmentObject private var notificationViewModel: NotificationCenterViewModel

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        NavigationStack {
            List {
                if notificationViewModel.notifications.isEmpty {
                    ContentUnavailableView(
                        "No Notifications",
                        systemImage: "bell.slash",
                        description: Text("Items that are expired or expiring soon will appear here.")
                    )
                } else {
                    ForEach(notificationViewModel.notifications) { notification in
                        NotificationRowView(notification: notification)
                    }
                }
            }
            .navigationTitle("Notifications")
        }
    }
}
