// RootView.swift
//
// Top-level router that decides whether to show the login flow or the main app. It also coordinates the grocery-list suggestion prompt when expiring items are detected.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// RootView groups related state and behavior for this feature.
struct RootView: View {
    // Shared authentication state for login/logout flows.
    @EnvironmentObject private var authViewModel: AuthViewModel
    // Shared inventory state used across the app.
    @EnvironmentObject private var inventoryViewModel: InventoryViewModel
    // Shared grocery list state and expiring-item suggestion logic.
    @EnvironmentObject private var groceryListViewModel: GroceryListViewModel
    // Shared notifications state derived from inventory items.
    @EnvironmentObject private var notificationViewModel: NotificationCenterViewModel

    // Controls whether the expiring-item grocery prompt alert is visible.
    @State private var showGroceryPrompt = false

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                HomeView()
                    .onAppear {
                        inventoryViewModel.reload()
                        groceryListViewModel.load()
                        groceryListViewModel.refreshSuggestions(from: inventoryViewModel.allItems)
                        showGroceryPrompt = groceryListViewModel.shouldShowPrompt
                    }
                    .onChange(of: inventoryViewModel.allItems.count) { _, _ in
                        groceryListViewModel.refreshSuggestions(from: inventoryViewModel.allItems)
                        showGroceryPrompt = groceryListViewModel.shouldShowPrompt
                    }
                    .alert("Add expiring items to grocery list?", isPresented: $showGroceryPrompt) {
                        Button("No", role: .cancel) {
                            groceryListViewModel.dismissSuggestionsForToday()
                        }

                        Button("Yes") {
                            groceryListViewModel.addPendingSuggestions()
                        }
                    } message: {
                        Text("Only items expiring within 3 days will be added to the grocery list.")
                    }
            } else {
                LoginView()
            }
        }
    }
}
