// StorageService.swift
//
// Generic JSON persistence service for saving and loading Codable data to local app storage.
// Added comments explain the purpose of the file and the role of important members.

import Foundation

// StorageService groups related state and behavior for this feature.
final class StorageService {
    static let shared = StorageService()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        encoder.outputFormatting = [.prettyPrinted]
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    private func fileURL(fileName: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }

    // Performs one focused piece of work for this file.
    func save<T: Encodable>(_ value: T, as fileName: String) {
        do {
            let data = try encoder.encode(value)
            try data.write(to: fileURL(fileName: fileName), options: [.atomic])
        } catch {
            print("Save error for \(fileName): \(error.localizedDescription)")
        }
    }

    // Loads previously saved data from disk.
    func load<T: Decodable>(_ type: T.Type, from fileName: String, defaultValue: T) -> T {
        do {
            let url = fileURL(fileName: fileName)
            guard FileManager.default.fileExists(atPath: url.path) else { return defaultValue }
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Load error for \(fileName): \(error.localizedDescription)")
            return defaultValue
        }
    }
}
