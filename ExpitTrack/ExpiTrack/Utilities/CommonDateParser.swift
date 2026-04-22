// CommonDateParser.swift
//
// Utility that attempts to parse several common grocery-style date formats entered by the user.
// Added comments explain the purpose of the file and the role of important members.

import Foundation

// CommonDateParser groups related state and behavior for this feature.
enum CommonDateParser {
    private static let formats = [
        "M/d/yy", "M/d/yyyy",
        "MM/dd/yy", "MM/dd/yyyy",
        "M-d-yy", "M-d-yyyy",
        "MM-dd-yy", "MM-dd-yyyy",
        "yyyy-MM-dd",
        "MMM d, yyyy", "MMMM d, yyyy"
    ]

    static func parse(_ text: String) -> Date? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        for format in formats {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = format
            if let date = formatter.date(from: trimmed) {
                return date
            }
        }
        return nil
    }
}
