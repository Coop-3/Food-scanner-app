// KeychainService.swift
//
// Small wrapper around the iOS Keychain for securely storing and retrieving credential values.
// Added comments explain the purpose of the file and the role of important members.

import Foundation
import Security

// KeychainService groups related state and behavior for this feature.
final class KeychainService {
    static let shared = KeychainService()
    private init() {}

    // Performs one focused piece of work for this file.
    func save(key: String, value: String) -> Bool {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        // Derived status for the current food item being displayed.
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // Performs one focused piece of work for this file.
    func read(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        // Single domain model being displayed or edited.
        var item: CFTypeRef?
        // Derived status for the current food item being displayed.
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }
}
