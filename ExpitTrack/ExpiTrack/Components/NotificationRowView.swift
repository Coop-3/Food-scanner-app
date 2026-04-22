// NotificationRowView.swift
//
// Reusable row used in the notifications screen to display one expiration-related notification.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// NotificationRowView groups related state and behavior for this feature.
struct NotificationRowView: View {
    // Single notification model displayed by the row.
    let notification: AppNotification

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: notification.status.systemImage)
                .foregroundStyle(notification.status.color)
                .font(.title3)

            VStack(alignment: .leading, spacing: 6) {
                Text(notification.itemName)
                    .font(.headline)
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Expiration: \(DateHelper.displayFormatter.string(from: notification.expirationDate))")
                    .font(.footnote)
                    .foregroundStyle(notification.status.color)
            }
        }
        .padding(.vertical, 6)
    }
}
