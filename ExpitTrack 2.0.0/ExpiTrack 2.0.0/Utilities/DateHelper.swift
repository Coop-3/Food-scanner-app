// DateHelper.swift
//
// Centralized date formatting and expiration text helper used across the app for consistent display.
// Added comments explain the purpose of the file and the role of important members.

import Foundation

// DateHelper groups related state and behavior for this feature.
enum DateHelper {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static func expirationText(for date: Date) -> String {
        // Derived status for the current food item being displayed.
        let status = FoodStatus.status(for: date)
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)
        let days = calendar.dateComponents([.day], from: today, to: target).day ?? 0

        switch status {
        case .fresh:
            return "Expires in \(days) days"
        case .expiringSoon:
            if days == 0 { return "Expires today" }
            return "Expires in \(days) day\(days == 1 ? "" : "s")"
        case .expired:
            if days == -1 { return "Expired 1 day ago" }
            return "Expired \(abs(days)) days ago"
        }
    }
}
