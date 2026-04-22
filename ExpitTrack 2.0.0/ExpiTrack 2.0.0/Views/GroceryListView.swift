// GroceryListView.swift
//
// Screen that shows grocery-list items, allows manual additions, and supports checking items off or deleting them.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// GroceryListView groups related state and behavior for this feature.
struct GroceryListView: View {
    // Shared grocery list state and expiring-item suggestion logic.
    @EnvironmentObject private var groceryListViewModel: GroceryListViewModel
    @State private var newItemName = ""

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    TextField("Add grocery list item", text: $newItemName)
                        .textFieldStyle(.roundedBorder)
                    Button("Add") {
                        groceryListViewModel.addManualItem(name: newItemName)
                        newItemName = ""
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                if groceryListViewModel.items.isEmpty {
                    ContentUnavailableView(
                        "No Grocery List Items",
                        systemImage: "cart",
                        description: Text("Expiring items can be added from the dashboard prompt, or add one manually here.")
                    )
                } else {
                    List {
                        ForEach(groceryListViewModel.items) { item in
                            Button {
                                groceryListViewModel.toggle(item)
                            } label: {
                                HStack {
                                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(item.isChecked ? .green : .secondary)
                                    Text(item.name)
                                        .strikethrough(item.isChecked)
                                        .foregroundStyle(item.isChecked ? .secondary : .primary)
                                    Spacer()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: groceryListViewModel.delete)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Grocery List")
        }
    }
}
