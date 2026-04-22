// ExpiTrackApp.swift
//
// Main application entry point. Creates shared view models once and injects them into the SwiftUI environment so every screen can access app state.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// Marks this type as the single application entry point for SwiftUI.
@main
// ExpiTrackApp groups related state and behavior for this feature.
struct ExpiTrackApp: App {
    // Shared authentication state for login/logout flows.
    @StateObject private var authViewModel = AuthViewModel()
    // Shared inventory state used across the app.
    @StateObject private var inventoryViewModel = InventoryViewModel()
    // Shared grocery list state and expiring-item suggestion logic.
    @StateObject private var groceryListViewModel = GroceryListViewModel()
    // Shared notifications state derived from inventory items.
    @StateObject private var notificationViewModel = NotificationCenterViewModel()

    // Initializes the type and prepares any starting state the app needs.
    init() {
        NotificationService.shared.requestAuthorization()
    }

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(inventoryViewModel)
                .environmentObject(groceryListViewModel)
                .environmentObject(notificationViewModel)
        }
    }
}
