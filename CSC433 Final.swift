import SwiftUI // Imports SwiftUI for building UI
import Foundation // Provides core data types and utilities
import AVFoundation // Enables camera functionality
import Vision // Enables text recognition (OCR)

// Model representing a grocery item
class GroceryItem: Identifiable, ObservableObject {
    let id = UUID() // Unique identifier for each item
    @Published var name: String // Name of the grocery item
    @Published var expirationDate: Date // Expiration date
    @Published var dateAdded: Date // Date item was added
    
    // Initializer to create a new grocery item
    init(name: String, expirationDate: Date) {
        self.name = name // Assign item name
        self.expirationDate = expirationDate // Assign expiration date
        self.dateAdded = Date() // Set current date as added date
    }
    
    // Calculates how many days remain until expiration
    var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
    }
    
    // Determines status based on days remaining
    var status: ItemStatus {
        if daysRemaining > 3 {
            return .fresh // Safe (green)
        } else if daysRemaining > 0 {
            return .warning // Near expiration (yellow)
        } else {
            return .expired // Expired (red)
        }
    }
}

// Enum representing item status states
enum ItemStatus {
    case fresh // Fresh item
    case warning // Near expiration
    case expired // Expired item
    
    // Returns a color based on status
    var color: Color {
        switch self {
        case .fresh:
            return .green // Green for safe
        case .warning:
            return .yellow // Yellow for warning
        case .expired:
            return .red // Red for expired
        }
    }
}

// Manager class handling app logic
class GroceryManager: ObservableObject {
    @Published var items: [GroceryItem] = [] // List of all items
    @Published var groceryList: [GroceryItem] = [] // Auto-generated grocery list
    
    // Adds a new grocery item
    func addItem(name: String, expirationDate: Date) {
        let item = GroceryItem(name: name, expirationDate: expirationDate) // Create item
        items.append(item) // Add to main list
        evaluateItem(item) // Check if it should go to grocery list
    }
    
    // Removes item(s) from list
    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets) // Delete items at given index
    }
    
    // Determines if item should be added to grocery list
    func evaluateItem(_ item: GroceryItem) {
        if item.daysRemaining <= 2 { // If close to expiration
            if !groceryList.contains(where: { $0.id == item.id }) { // Avoid duplicates
                groceryList.append(item) // Add to grocery list
            }
        }
    }
    
    // Refreshes grocery list (e.g., when app opens)
    func refreshItems() {
        groceryList.removeAll() // Clear existing grocery list
        for item in items { // Re-check all items
            evaluateItem(item)
        }
    }
}

// ViewModel for handling camera and OCR
class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession() // Camera session
    @Published var output = AVCapturePhotoOutput() // Photo capture output
    @Published var previewLayer: AVCaptureVideoPreviewLayer? // Camera preview layer
    @Published var recognizedDate: Date? // Detected expiration date
    
    // Starts the camera session
    func startSession() {
        session.beginConfiguration() // Begin configuring session
        guard let device = AVCaptureDevice.default(for: .video), // Get camera device
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        if session.canAddInput(input) { session.addInput(input) } // Add camera input
        if session.canAddOutput(output) { session.addOutput(output) } // Add photo output
        
        session.commitConfiguration() // Commit configuration
        session.startRunning() // Start camera
    }
    
    // Captures a photo
    func capturePhoto() {
        let settings = AVCapturePhotoSettings() // Photo settings
        output.capturePhoto(with: settings, delegate: self) // Take photo
    }
    
    // Called after photo is captured
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(), // Convert to data
              let image = UIImage(data: data) else { return }
        recognizeText(image: image) // Run OCR
    }
    
    // Uses Vision to recognize text in image
    func recognizeText(image: UIImage) {
        let request = VNRecognizeTextRequest { request, _ in
            guard let results = request.results as? [VNRecognizedTextObservation] else { return }
            
            for observation in results { // Loop through detected text
                if let text = observation.topCandidates(1).first?.string { // Get best match
                    if let date = self.extractDate(from: text) { // Try to find date
                        DispatchQueue.main.async {
                            self.recognizedDate = date // Save detected date
                        }
                        break // Stop after finding one date
                    }
                }
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:]) // Create handler
        try? handler.perform([request]) // Execute OCR request
    }
    
    // Extracts date from text using detector
    func extractDate(from text: String) -> Date? {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue) // Create detector
        let matches = detector?.matches(in: text, range: NSRange(text.startIndex..., in: text)) // Find matches
        return matches?.first?.date // Return first detected date
    }
}

// UIView wrapper for camera preview
struct CameraView: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewModel // Connect ViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds) // Create view
        viewModel.previewLayer = AVCaptureVideoPreviewLayer(session: viewModel.session) // Attach session
        viewModel.previewLayer?.frame = view.frame // Set frame
        viewModel.previewLayer?.videoGravity = .resizeAspectFill // Fill screen
        view.layer.addSublayer(viewModel.previewLayer!) // Add preview layer
        viewModel.startSession() // Start camera
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// Main UI
struct ContentView: View {
    @StateObject private var manager = GroceryManager() // App data manager
    @StateObject private var cameraVM = CameraViewModel() // Camera ViewModel
    @State private var itemName: String = "" // Input for item name
    @State private var expirationDate: Date = Date() // Selected expiration date
    @State private var showCamera = false // Controls camera modal
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Item name", text: $itemName) // Input field
                        DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date) // Date picker
                        
                        Button("Scan Expiration Date") {
                            showCamera = true // Open camera
                        }
                        
                        Button("Add") {
                            guard !itemName.isEmpty else { return } // Prevent empty input
                            manager.addItem(name: itemName, expirationDate: expirationDate) // Add item
                            itemName = "" // Reset input
                        }
                    }
                }
                
                List {
                    Section(header: Text("Items")) {
                        ForEach(manager.items) { item in
                            HStack {
                                Circle()
                                    .fill(item.status.color) // Color indicator
                                    .frame(width: 12, height: 12)
                                VStack(alignment: .leading) {
                                    Text(item.name) // Item name
                                    Text(item.expirationDate, style