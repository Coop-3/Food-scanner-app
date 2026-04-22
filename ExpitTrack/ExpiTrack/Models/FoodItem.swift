// FoodItem.swift
//
// Core model for a tracked grocery item in the inventory.
// Added comments explain the purpose of the file and the role of important members.

import Foundation

// FoodItem groups related state and behavior for this feature.
struct FoodItem: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var quantity: String
    var expirationDate: Date
    var storageLocation: StorageLocation
    var imageFileName: String?
    var createdAt: Date
    var updatedAt: Date
    var savedTemplateName: String?

    // Initializes the type and prepares any starting state the app needs.
    init(
        id: UUID = UUID(),
        name: String,
        quantity: String,
        expirationDate: Date,
        storageLocation: StorageLocation = .fridge,
        imageFileName: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        savedTemplateName: String? = nil
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.expirationDate = expirationDate
        self.storageLocation = storageLocation
        self.imageFileName = imageFileName
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.savedTemplateName = savedTemplateName
    }
}
