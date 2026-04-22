// GroceryListItem.swift
//
// Model representing one row in the grocery list.
// Added comments explain the purpose of the file and the role of important members.

import Foundation

// GroceryListItem groups related state and behavior for this feature.
struct GroceryListItem: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var sourceItemID: UUID?
    var createdAt: Date
    var isChecked: Bool

    // Initializes the type and prepares any starting state the app needs.
    init(id: UUID = UUID(), name: String, sourceItemID: UUID? = nil, createdAt: Date = Date(), isChecked: Bool = false) {
        self.id = id
        self.name = name
        self.sourceItemID = sourceItemID
        self.createdAt = createdAt
        self.isChecked = isChecked
    }
}
