import Foundation

/// Utility responsible for detecting and parsing expiration dates from scanned text.
/// This acts as the "brain" of the scanning feature.
enum ExpirationDateDetector {

    /// Main function used by scanner to extract a valid Date from raw OCR text.
    static func detectDate(from rawText: String) -> Date? {
        // Normalize common OCR mistakes (O → 0, etc.)
        let normalized = normalize(rawText)

        // Split into lines for more accurate parsing
        let lines = normalized
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        // Prioritize lines that likely contain expiration info
        for line in prioritizedLines(from: lines) {
            if let date = extractDate(from: line) {
                return date
            }
        }

        // Fallback: scan entire text block if line parsing fails
        return extractDate(from: normalized)
    }

    /// Formats a Date into a readable string for confirmation UI.
    static func displayString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    // MARK: - Private Helpers

    /// Prioritizes lines containing keywords like "EXP", "BEST BY", etc.
    private static func prioritizedLines(from lines: [String]) -> [String] {
        let keywords = [
            "exp", "expires", "expiration",
            "best by", "use by", "sell by"
        ]

        let prioritized = lines.filter { line in
            let lowered = line.lowercased()
            return keywords.contains(where: { lowered.contains($0) })
        }

        // If keyword matches exist, prioritize them
        return prioritized.isEmpty ? lines : prioritized + lines
    }

    /// Cleans up OCR errors before parsing.
    private static func normalize(_ text: String) -> String {
        text
            .replacingOccurrences(of: "O", with: "0")
            .replacingOccurrences(of: "o", with: "0")
            .replacingOccurrences(of: "|", with: "/")
    }

    /// Attempts to extract a date string using regex patterns.
    private static func extractDate(from text: String) -> Date? {
        let patterns = [
            #"\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b"#, // 04/22/2026
            #"\b\d{4}[/-]\d{1,2}[/-]\d{1,2}\b"#    // 2026-04-22
        ]

        for pattern in patterns {
            if let match = firstMatch(for: pattern, in: text),
               let date = parseCandidate(match) {
                return date
            }
        }

        return nil
    }

    /// Finds first regex match in text.
    private static func firstMatch(for pattern: String, in text: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }

        let range = NSRange(text.startIndex..., in: text)
        guard let match = regex.firstMatch(in: text, range: range),
              let swiftRange = Range(match.range, in: text) else { return nil }

        return String(text[swiftRange])
    }

    /// Converts matched string into Date object using multiple formats.
    private static func parseCandidate(_ candidate: String) -> Date? {
        let formats = [
            "M/d/yyyy", "MM/dd/yyyy",
            "M/d/yy", "MM/dd/yy",
            "yyyy-MM-dd"
        ]

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: candidate) {
                return date
            }
        }

        return nil
    }
}
