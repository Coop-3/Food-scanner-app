// ItemCardView.swift
//
// Reusable card used on the home screen to display one food item with its image, quantity, location, expiration text, and status badge.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI
import UIKit

// ItemCardView groups related state and behavior for this feature.
struct ItemCardView: View {
    // Single domain model being displayed or edited.
    let item: FoodItem
    // Optional image used by the current card or form.
    let image: UIImage?

    // Derived status for the current food item being displayed.
    // Derived status for the current food item being displayed.
    private var status: FoodStatus {
        FoodStatus.status(for: item.expirationDate)
    }

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray6))

                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(item.name)
                .font(.headline)
                .lineLimit(1)

            Text(item.quantity)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Label(item.storageLocation.rawValue, systemImage: item.storageLocation.systemImage)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Text(DateHelper.expirationText(for: item.expirationDate))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(status.color)

            StatusBadgeView(status: status)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
