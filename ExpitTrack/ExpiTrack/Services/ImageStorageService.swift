// ImageStorageService.swift
//
// Service responsible for saving, loading, and deleting item photos in the app's documents directory.
// Added comments explain the purpose of the file and the role of important members.

import Foundation
import UIKit

// ImageStorageService groups related state and behavior for this feature.
final class ImageStorageService {
    static let shared = ImageStorageService()
    private init() {}

    private var directoryURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directory = documents.appendingPathComponent("ItemImages", isDirectory: true)
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        return directory
    }

    // Saves a UIImage to disk and returns the generated file name if successful.
    func saveImage(_ image: UIImage) -> String? {
        // Local file name used for JSON persistence.
        let fileName = "\(UUID().uuidString).jpg"
        let url = directoryURL.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.85) else { return nil }

        do {
            try data.write(to: url, options: [.atomic])
            return fileName
        } catch {
            print("Image save failed: \(error.localizedDescription)")
            return nil
        }
    }

    // Loads a saved image from disk using its file name.
    func loadImage(fileName: String?) -> UIImage? {
        guard let fileName else { return nil }
        let url = directoryURL.appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    // Deletes a saved image file if it exists.
    func deleteImage(fileName: String?) {
        guard let fileName else { return }
        let url = directoryURL.appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
    }
}
