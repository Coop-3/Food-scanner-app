// FoodStatus.swift
//
// Domain logic for classifying items as fresh, expiring soon, or expired, plus their matching UI styles.
// Added comments explain the purpose of the file and the role of important members.

import Foundation
import SwiftUI

// FoodStatus groups related state and behavior for this feature.
enum FoodStatus: String, Codable, CaseIterable {
    case fresh = "Fresh"
    case expiringSoon = "Expiring Soon"
    case expired = "Expired"

    static func status(for expirationDate: Date, calendar: Calendar = .current) -> FoodStatus {
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfExpiration = calendar.startOfDay(for: expirationDate)
        let daysRemaining = calendar.dateComponents([.day], from: startOfToday, to: startOfExpiration).day ?? 0

        if daysRemaining < 0 {
            return .expired
        } else if daysRemaining <= 3 {
            return .expiringSoon
        } else {
            return .fresh
        }
    }

    var color: Color {
        switch self {
        case .fresh:
            return .green
        case .expiringSoon:
            return .orange
        case .expired:
            return .red
        }
    }

    var systemImage: String {
        switch self {
        case .fresh:
            return "checkmark.circle.fill"
        case .expiringSoon:
            return "exclamationmark.triangle.fill"
        case .expired:
            return "xmark.octagon.fill"
        }
    }
}
