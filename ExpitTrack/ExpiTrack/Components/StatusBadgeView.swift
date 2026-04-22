// StatusBadgeView.swift
//
// Reusable badge that shows a food item's freshness state using text, icon, and color.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// StatusBadgeView groups related state and behavior for this feature.
struct StatusBadgeView: View {
    // Derived status for the current food item being displayed.
    let status: FoodStatus

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: status.systemImage)
            Text(status.rawValue)
                .fontWeight(.semibold)
        }
        .font(.caption)
        .foregroundStyle(status.color)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(status.color.opacity(0.12))
        .clipShape(Capsule())
    }
}
