// InventoryViewModel.swift
//
// Main inventory view model. Handles loading, saving, searching, sorting, template lookup, and item CRUD operations.
// Added comments explain the purpose of the file and the role of important members.

import Foundation
import Combine
import UIKit

@MainActor
// InventoryViewModel groups related state and behavior for this feature.
final class InventoryViewModel: ObservableObject {
    // Primary collection stored and displayed by this view model.
    @Published private(set) var items: [FoodItem] = []
    // Current user-selected inventory sort mode.
    @Published var sortOption: InventorySortOption = .recentlyAdded
    // Current search query used to filter inventory items.
    @Published var searchText = ""

    // Shared persistence service used for Codable data.
    private let storage = StorageService.shared
    // Shared file-based image storage service.
    private let imageStorage = ImageStorageService.shared
    // Local file name used for JSON persistence.
    private let fileName = "food_items.json"

    // Read-only access to the full inventory array.
    // Read-only access to the full inventory array.
    var allItems: [FoodItem] {
        items
    }

    // Inventory items after search filtering and sorting have been applied.
    // Inventory items after search filtering and sorting have been applied.
    var filteredItems: [FoodItem] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        let baseItems: [FoodItem]
        if trimmed.isEmpty {
            baseItems = items
        } else {
            baseItems = items.filter {
                $0.name.localizedCaseInsensitiveContains(trimmed) ||
                $0.quantity.localizedCaseInsensitiveContains(trimmed) ||
                $0.storageLocation.rawValue.localizedCaseInsensitiveContains(trimmed)
            }
        }

        switch sortOption {
        case .recentlyAdded:
            return baseItems.sorted { $0.createdAt > $1.createdAt }
        case .expirationDate:
            return baseItems.sorted { $0.expirationDate < $1.expirationDate }
        }
    }

    // Inventory items that are still fresh or expiring soon.
    // Inventory items that are still fresh or expiring soon.
    var activeItems: [FoodItem] {
        filteredItems.filter { FoodStatus.status(for: $0.expirationDate) != .expired }
    }

    // Inventory items that are already expired.
    // Inventory items that are already expired.
    var expiredItems: [FoodItem] {
        filteredItems.filter { FoodStatus.status(for: $0.expirationDate) == .expired }
    }

    // Inventory items that fall within the “expiring soon” range.
    // Inventory items that fall within the “expiring soon” range.
    var expiringSoonItems: [FoodItem] {
        filteredItems.filter { FoodStatus.status(for: $0.expirationDate) == .expiringSoon }
    }

    // Count used by the summary banner for soon-to-expire items.
    // Count used by the summary banner for soon-to-expire items.
    var expiringSoonCount: Int {
        allItems.filter { FoodStatus.status(for: $0.expirationDate) == .expiringSoon }.count
    }

    // Total number of saved inventory items.
    // Total number of saved inventory items.
    var totalItemCount: Int {
        allItems.count
    }

    // Count of items whose status is expired.
    // Count of items whose status is expired.
    var expiredCount: Int {
        allItems.filter { FoodStatus.status(for: $0.expirationDate) == .expired }.count
    }

    // Headline shown in the home-screen summary banner.
    // Headline shown in the home-screen summary banner.
    var summaryBannerTitle: String {
        if expiringSoonCount == 0 {
            return "Nothing is expiring soon"
        } else if expiringSoonCount == 1 {
            return "1 item is expiring within 3 days"
        } else {
            return "\(expiringSoonCount) items are expiring within 3 days"
        }
    }

    // Supporting explanation shown below the summary banner headline.
    // Supporting explanation shown below the summary banner headline.
    var summaryBannerSubtitle: String {
        if expiringSoonCount == 0 {
            return "You're in good shape. Keep tracking items to stay ahead of expiration dates."
        } else {
            return "Review these items soon or add them to your grocery list when needed."
        }
    }

    // Initializes the type and prepares any starting state the app needs.
    init() {
        reload()
    }

    // Reloads persisted data from local storage into memory.
    func reload() {
        items = storage.load([FoodItem].self, from: fileName, defaultValue: [])
    }

    // Creates a new inventory item, optionally saves its photo, and persists the updated list.
    func addItem(
        name: String,
        quantity: String,
        expirationDate: Date,
        storageLocation: StorageLocation,
        image: UIImage?,
        savePhotoTemplate: Bool
    ) {
        let imageFileName = image.flatMap { imageStorage.saveImage($0) }

        // Single domain model being displayed or edited.
        let item = FoodItem(
            name: name,
            quantity: quantity,
            expirationDate: expirationDate,
            storageLocation: storageLocation,
            imageFileName: imageFileName,
            savedTemplateName: (savePhotoTemplate && imageFileName != nil) ? name : nil
        )

        items.append(item)
        persist()
    }

    // Updates an existing inventory item and persists the changes.
    func updateItem(
        _ item: FoodItem,
        name: String,
        quantity: String,
        expirationDate: Date,
        storageLocation: StorageLocation,
        newImage: UIImage?,
        keepExistingImage: Bool,
        savePhotoTemplate: Bool
    ) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }

        var updated = item
        updated.name = name
        updated.quantity = quantity
        updated.expirationDate = expirationDate
        updated.storageLocation = storageLocation
        updated.updatedAt = Date()

        if let newImage {
            imageStorage.deleteImage(fileName: item.imageFileName)
            updated.imageFileName = imageStorage.saveImage(newImage)
        } else if !keepExistingImage {
            imageStorage.deleteImage(fileName: item.imageFileName)
            updated.imageFileName = nil
        }

        updated.savedTemplateName = (savePhotoTemplate && updated.imageFileName != nil) ? name : nil

        items[index] = updated
        persist()
    }

    // Removes an inventory item and its saved image from storage.
    func deleteItem(_ item: FoodItem) {
        imageStorage.deleteImage(fileName: item.imageFileName)
        items.removeAll { $0.id == item.id }
        persist()
    }

    // Loads the saved image associated with a food item.
    func image(for item: FoodItem) -> UIImage? {
        imageStorage.loadImage(fileName: item.imageFileName)
    }

    // Finds the newest saved template item that matches a given item name.
    func savedTemplateItem(for rawName: String) -> FoodItem? {
        let normalized = normalize(rawName)

        return items
            .filter {
                guard let templateName = $0.savedTemplateName,
                      $0.imageFileName != nil else {
                    return false
                }

                return normalize(templateName) == normalized
            }
            .sorted { $0.updatedAt > $1.updatedAt }
            .first
    }

    // Loads the saved template image that matches a given item name.
    func savedTemplateImage(for rawName: String) -> UIImage? {
        guard let templateItem = savedTemplateItem(for: rawName) else { return nil }
        return image(for: templateItem)
    }

    private func normalize(_ text: String) -> String {
        text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }

    private func persist() {
        storage.save(items, as: fileName)
    }
}

// InventorySortOption groups related state and behavior for this feature.
enum InventorySortOption: String, CaseIterable, Identifiable {
    case recentlyAdded = "Recently Added"
    case expirationDate = "Expiration Date"

    var id: String { rawValue }
}
