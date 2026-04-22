// SectionHeaderView.swift
//
// Simple reusable section title used to visually separate major areas of a screen.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// SectionHeaderView groups related state and behavior for this feature.
struct SectionHeaderView: View {
    // Section title text supplied by the caller.
    let title: String

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        HStack {
            Text(title)
                .font(.title3.bold())
            Spacer()
        }
    }
}
