// AppNotification.swift
//
// Model representing one in-app notification item shown in the notifications list.
// Added comments explain the purpose of the file and the role of important members.

import Foundation

// AppNotification groups related state and behavior for this feature.
struct AppNotification: Identifiable, Codable, Equatable {
    let id: UUID
    let itemID: UUID
    let itemName: String
    let expirationDate: Date
    let message: String
    // Derived status for the current food item being displayed.
    let status: FoodStatus
    let createdAt: Date

    // Initializes the type and prepares any starting state the app needs.
    init(id: UUID = UUID(), itemID: UUID, itemName: String, expirationDate: Date, message: String, status: FoodStatus, createdAt: Date = Date()) {
        self.id = id
        self.itemID = itemID
        self.itemName = itemName
        self.expirationDate = expirationDate
        self.message = message
        self.status = status
        self.createdAt = createdAt
    }
}
