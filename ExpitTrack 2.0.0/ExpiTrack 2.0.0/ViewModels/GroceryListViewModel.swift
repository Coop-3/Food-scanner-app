// GroceryListViewModel.swift
//
// View model for the grocery list screen and expiring-item suggestions. Controls list persistence, prompting rules, and list actions.
// Added comments explain the purpose of the file and the role of important members.

import Foundation
import Combine
import SwiftUI

@MainActor
// GroceryListViewModel groups related state and behavior for this feature.
final class GroceryListViewModel: ObservableObject {
    // Primary collection stored and displayed by this view model.
    @Published private(set) var items: [GroceryListItem] = []
    // Inventory items currently suggested for addition to the grocery list.
    @Published var suggestedItems: [FoodItem] = []

    // Shared persistence service used for Codable data.
    private let storage = StorageService.shared
    // Local file name used for JSON persistence.
    private let fileName = "grocery_list.json"
    private let promptSeenKey = "expitrack.promptSeenDate"

    // Initializes the type and prepares any starting state the app needs.
    init() {
        load()
    }

    // Loads previously saved data from disk.
    func load() {
        items = storage.load([GroceryListItem].self, from: fileName, defaultValue: [])
    }

    // Finds inventory items that should be suggested for the grocery list.
    func refreshSuggestions(from inventoryItems: [FoodItem]) {
        suggestedItems = inventoryItems.filter {
            FoodStatus.status(for: $0.expirationDate) == .expiringSoon
        }
        .filter { candidate in
            !items.contains {
                if let sourceItemID = $0.sourceItemID {
                    return sourceItemID == candidate.id
                }

                return $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    == candidate.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            }
        }
    }

    // Adds the currently suggested expiring items to the grocery list.
    func addPendingSuggestions() {
        // Inventory items that fall within the “expiring soon” range.
        let expiringSoonItems = suggestedItems.filter {
            FoodStatus.status(for: $0.expirationDate) == .expiringSoon
        }

        let newItems = expiringSoonItems.map {
            GroceryListItem(name: $0.name, sourceItemID: $0.id)
        }

        items.append(contentsOf: newItems)
        suggestedItems.removeAll()
        markPromptSeenToday()
        persist()
    }

    // Marks the grocery prompt as seen so it does not keep reappearing the same day.
    func dismissSuggestionsForToday() {
        markPromptSeenToday()
    }

    var shouldShowPrompt: Bool {
        !suggestedItems.isEmpty && !hasSeenPromptToday()
    }

    // Appends a user-entered grocery item to the grocery list.
    func addManualItem(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        items.append(GroceryListItem(name: trimmed))
        persist()
    }

    // Toggles whether a grocery-list item is checked off.
    func toggle(_ item: GroceryListItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isChecked.toggle()
        persist()
    }

    // Deletes one or more grocery-list items using list swipe actions.
    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        persist()
    }

    private func hasSeenPromptToday() -> Bool {
        guard let storedDate = UserDefaults.standard.object(forKey: promptSeenKey) as? Date else {
            return false
        }
        return Calendar.current.isDateInToday(storedDate)
    }

    private func markPromptSeenToday() {
        UserDefaults.standard.set(Date(), forKey: promptSeenKey)
    }

    private func persist() {
        storage.save(items, as: fileName)
    }
}
