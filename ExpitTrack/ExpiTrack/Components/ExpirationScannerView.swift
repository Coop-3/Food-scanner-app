import SwiftUI
import VisionKit

/// Wraps Apple's DataScannerViewController for use in SwiftUI.
/// Handles live camera scanning of text.
struct ExpirationScannerView: UIViewControllerRepresentable {

    // Called when a valid date is detected
    let onDateDetected: (Date) -> Void

    // Called when user cancels scanning
    let onCancel: () -> Void

    // Called when scanner fails
    let onFailure: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDateDetected: onDateDetected, onFailure: onFailure)
    }

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let controller = DataScannerViewController(
            recognizedDataTypes: [.text()], // Scan text only
            qualityLevel: .accurate,
            recognizesMultipleItems: true
        )

        controller.delegate = context.coordinator
        try? controller.startScanning() // Start camera scanning
        return controller
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}

    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }

    /// Handles scanning results
    final class Coordinator: NSObject, DataScannerViewControllerDelegate {

        private let onDateDetected: (Date) -> Void
        private let onFailure: (String) -> Void

        private var hasDetected = false

        init(onDateDetected: @escaping (Date) -> Void,
             onFailure: @escaping (String) -> Void) {
            self.onDateDetected = onDateDetected
            self.onFailure = onFailure
        }

        /// Called when scanner detects new text
        func dataScanner(_ scanner: DataScannerViewController,
                         didAdd items: [RecognizedItem],
                         allItems: [RecognizedItem]) {

            guard !hasDetected else { return }

            let text = items.compactMap {
                if case .text(let t) = $0 { return t.transcript }
                return nil
            }.joined(separator: "\n")

            if let date = ExpirationDateDetector.detectDate(from: text) {
                hasDetected = true
                scanner.stopScanning()
                onDateDetected(date)
            }
        }
    }
}
