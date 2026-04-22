// HomeView.swift
//
// Primary dashboard screen showing summary stats, inventory cards, expired items, search, sorting, and navigation to related screens.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// HomeView groups related state and behavior for this feature.
struct HomeView: View {
    // Shared inventory state used across the app.
    @EnvironmentObject private var inventoryViewModel: InventoryViewModel
    // Shared notifications state derived from inventory items.
    @EnvironmentObject private var notificationViewModel: NotificationCenterViewModel
    // Shared grocery list state and expiring-item suggestion logic.
    @EnvironmentObject private var groceryListViewModel: GroceryListViewModel
    // Shared authentication state for login/logout flows.
    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var showAddItem = false
    @State private var selectedItem: FoodItem?

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    summaryBanner

                    Picker("Sort", selection: $inventoryViewModel.sortOption) {
                        ForEach(InventorySortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)

                    if inventoryViewModel.filteredItems.isEmpty {
                        ContentUnavailableView(
                            "No Items Yet",
                            systemImage: "tray",
                            description: Text("Tap the plus button to add your first grocery item.")
                        )
                        .padding(.top, 40)
                    } else {
                        if !inventoryViewModel.activeItems.isEmpty {
                            SectionHeaderView(title: "Inventory")
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(inventoryViewModel.activeItems) { item in
                                    Button {
                                        selectedItem = item
                                    } label: {
                                        ItemCardView(item: item, image: inventoryViewModel.image(for: item))
                                    }
                                    .buttonStyle(.plain)
                                    .contextMenu {
                                        Button("Edit") {
                                            selectedItem = item
                                        }

                                        Button("Delete", role: .destructive) {
                                            inventoryViewModel.deleteItem(item)
                                        }
                                    }
                                }
                            }
                        }

                        if !inventoryViewModel.expiredItems.isEmpty {
                            SectionHeaderView(title: "Expired")
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(inventoryViewModel.expiredItems) { item in
                                    Button {
                                        selectedItem = item
                                    } label: {
                                        ItemCardView(item: item, image: inventoryViewModel.image(for: item))
                                    }
                                    .buttonStyle(.plain)
                                    .contextMenu {
                                        Button("Edit") {
                                            selectedItem = item
                                        }

                                        Button("Delete", role: .destructive) {
                                            inventoryViewModel.deleteItem(item)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .searchable(text: $inventoryViewModel.searchText, prompt: "Search items")
            .navigationTitle("ExpiTrack")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Logout") {
                        authViewModel.logout()
                    }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink {
                        GroceryListView()
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart")

                            if !groceryListViewModel.items.isEmpty {
                                Text("\(groceryListViewModel.items.count)")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(4)
                                    .background(Color.green)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }

                    NavigationLink {
                        NotificationsView()
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell")

                            if !notificationViewModel.notifications.isEmpty {
                                Text("\(notificationViewModel.notifications.count)")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(4)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }

                    Button {
                        showAddItem = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddItem) {
                AddEditItemView(mode: .add)
            }
            .sheet(item: $selectedItem) { item in
                AddEditItemView(mode: .edit(item))
            }
        }
    }

    private var summaryBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: inventoryViewModel.expiringSoonCount > 0 ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(inventoryViewModel.expiringSoonCount > 0 ? .orange : .green)

                VStack(alignment: .leading, spacing: 4) {
                    Text(inventoryViewModel.summaryBannerTitle)
                        .font(.headline)

                    Text(inventoryViewModel.summaryBannerSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            HStack(spacing: 12) {
                summaryStat(title: "Total", value: "\(inventoryViewModel.totalItemCount)")
                summaryStat(title: "Soon", value: "\(inventoryViewModel.expiringSoonCount)")
                summaryStat(title: "Expired", value: "\(inventoryViewModel.expiredCount)")
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func summaryStat(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.headline)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
