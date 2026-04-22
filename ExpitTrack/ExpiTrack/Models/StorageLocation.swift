// StorageLocation.swift
//
// Enum describing where a food item is stored in the home.
// Added comments explain the purpose of the file and the role of important members.

import Foundation

// StorageLocation groups related state and behavior for this feature.
enum StorageLocation: String, Codable, CaseIterable, Identifiable {
    case fridge = "Fridge"
    case freezer = "Freezer"
    case pantry = "Pantry"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .fridge:
            return "refrigerator"
        case .freezer:
            return "snowflake"
        case .pantry:
            return "cabinet"
        }
    }
}
