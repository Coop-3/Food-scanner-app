// MainTabView.swift
//
// Optional tab-based container for the main sections of the app. Keeps navigation simple by grouping inventory, grocery list, and notifications.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// MainTabView groups related state and behavior for this feature.
struct MainTabView: View {
    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Inventory", systemImage: "house.fill")
                }

            GroceryListView()
                .tabItem {
                    Label("Grocery List", systemImage: "cart.fill")
                }

            NotificationsView()
                .tabItem {
                    Label("Notifications", systemImage: "bell.fill")
                }
        }
        .tint(.green)
    }
}
