import SwiftUI
import PhotosUI
import UIKit
import VisionKit

/// View used for both adding and editing food items.
/// Includes manual entry + camera/photo + expiration date scanning.
struct AddEditItemView: View {

    // MARK: - Mode (Add vs Edit)

    enum Mode {
        case add
        case edit(FoodItem)

        var title: String {
            switch self {
            case .add: return "Add Item"
            case .edit: return "Edit Item"
            }
        }
    }

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var inventoryViewModel: InventoryViewModel

    let mode: Mode

    // MARK: - Input State

    @State private var name = ""
    @State private var quantity = "1"
    @State private var expirationDate = Date()
    @State private var storageLocation: StorageLocation = .fridge
    @State private var manualDateText = ""

    // MARK: - Image State

    @State private var selectedImage: UIImage?
    @State private var existingImage: UIImage?
    @State private var keepExistingImage = true
    @State private var showCamera = false
    @State private var selectedPhotoItem: PhotosPickerItem?

    @State private var saveTemplate = false

    // MARK: - Validation

    @State private var showValidationAlert = false
    @State private var validationMessage = ""

    // MARK: - Scanner State

    @State private var showExpirationScanner = false
    @State private var scannerDetectedDate: Date?
    @State private var showDetectedDateConfirmation = false
    @State private var scannerErrorMessage = ""
    @State private var showScannerError = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {

                // MARK: Item Details
                Section("Item Details") {
                    TextField("Food name", text: $name)
                    TextField("Quantity", text: $quantity)

                    Picker("Location", selection: $storageLocation) {
                        ForEach(StorageLocation.allCases) { location in
                            Text(location.rawValue).tag(location)
                        }
                    }
                }

                // MARK: Expiration Date Section
                Section("Expiration Date") {

                    // Manual picker
                    DatePicker("Select Date", selection: $expirationDate, displayedComponents: .date)

                    // Manual typing
                    TextField("Or type date (MM/DD/YYYY)", text: $manualDateText)
                        .keyboardType(.numbersAndPunctuation)
                        .onChange(of: manualDateText) { _, newValue in
                            if let parsed = CommonDateParser.parse(newValue) {
                                expirationDate = parsed
                            }
                        }

                    // Scanner button
                    if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                        Button {
                            showExpirationScanner = true
                        } label: {
                            Label("Scan Expiration Date", systemImage: "viewfinder")
                        }
                    } else {
                        Text("Scanner not available on this device.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                // MARK: Photo Section
                Section("Photo") {

                    HStack {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Label("Choose Photo", systemImage: "photo")
                        }
                        .onChange(of: selectedPhotoItem) { _, newItem in
                            loadImage(from: newItem)
                        }

                        Button {
                            showCamera = true
                        } label: {
                            Label("Camera", systemImage: "camera")
                        }
                    }

                    if let previewImage {
                        Image(uiImage: previewImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Toggle("Save photo for future use", isOn: $saveTemplate)
                }
            }
            .navigationTitle(mode.title)

            // MARK: Toolbar
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { saveItem() }
                }
            }

            // MARK: Camera Sheet
            .sheet(isPresented: $showCamera) {
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
            }

            // MARK: Scanner Sheet
            .sheet(isPresented: $showExpirationScanner) {
                ExpirationScannerView(
                    onDateDetected: { detectedDate in
                        scannerDetectedDate = detectedDate
                        showExpirationScanner = false

                        // Show confirmation after scan
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            showDetectedDateConfirmation = true
                        }
                    },
                    onCancel: {
                        showExpirationScanner = false
                    },
                    onFailure: { message in
                        scannerErrorMessage = message
                        showScannerError = true
                    }
                )
            }

            // MARK: Confirmation Alert
            .alert("Detected Date", isPresented: $showDetectedDateConfirmation) {
                Button("Rescan") {
                    showExpirationScanner = true
                }

                Button("Use Date") {
                    if let detected = scannerDetectedDate {
                        expirationDate = detected
                        manualDateText = DateHelper.displayFormatter.string(from: detected)
                    }
                }
            } message: {
                if let detected = scannerDetectedDate {
                    Text("Use \(ExpirationDateDetector.displayString(for: detected))?")
                }
            }

            // MARK: Error Alerts
            .alert("Error", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }

            .alert("Scanner Error", isPresented: $showScannerError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(scannerErrorMessage)
            }

            .onAppear(perform: configure)
        }
    }

    // MARK: - Helpers

    /// Image preview logic
    private var previewImage: UIImage? {
        selectedImage ?? (keepExistingImage ? existingImage : nil)
    }

    /// Load selected photo from gallery
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }

        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
            }
        }
    }

    /// Configure edit mode
    private func configure() {
        if case .edit(let item) = mode {
            name = item.name
            quantity = item.quantity
            expirationDate = item.expirationDate
            storageLocation = item.storageLocation
            existingImage = inventoryViewModel.image(for: item)
        }
    }

    /// Save item (add or update)
    private func saveItem() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            validationMessage = "Enter a name."
            showValidationAlert = true
            return
        }

        switch mode {
        case .add:
            inventoryViewModel.addItem(
                name: trimmedName,
                quantity: quantity,
                expirationDate: expirationDate,
                storageLocation: storageLocation,
                image: selectedImage,
                savePhotoTemplate: saveTemplate
            )

        case .edit(let item):
            inventoryViewModel.updateItem(
                item,
                name: trimmedName,
                quantity: quantity,
                expirationDate: expirationDate,
                storageLocation: storageLocation,
                newImage: selectedImage,
                keepExistingImage: keepExistingImage,
                savePhotoTemplate: saveTemplate
            )
        }

        dismiss()
    }
}
