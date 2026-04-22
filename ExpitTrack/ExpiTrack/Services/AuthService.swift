// AuthService.swift
//
// Authentication service that signs up users, logs them in, and persists their credentials and login state using local secure storage.
// Added comments explain the purpose of the file and the role of important members.

import Foundation

// AuthService groups related state and behavior for this feature.
final class AuthService {
    static let shared = AuthService()

    private enum Keys {
        static let username = "expitrack.username"
        static let password = "expitrack.password"
        static let loggedIn = "expitrack.loggedIn"
    }

    private init() {}

    // Checks whether the app already has a saved local account.
    func hasAccount() -> Bool {
        // Bound username field used on the login screen.
        let username = KeychainService.shared.read(key: Keys.username)
        // Bound password field used on the login screen.
        let password = KeychainService.shared.read(key: Keys.password)
        return !(username?.isEmpty ?? true) && !(password?.isEmpty ?? true)
    }

    // Returns the stored username if one exists.
    func currentUsername() -> String? {
        KeychainService.shared.read(key: Keys.username)
    }

    // Returns the app’s current login state from local storage.
    func isLoggedIn() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.loggedIn)
    }

    @discardableResult
    // Validates and stores a new local account.
    func signUp(username: String, password: String) -> Result<Void, AuthError> {
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .failure(.emptyUsername)
        }
        guard password.count >= 4 else {
            return .failure(.shortPassword)
        }

        let didSaveUser = KeychainService.shared.save(key: Keys.username, value: username)
        let didSavePassword = KeychainService.shared.save(key: Keys.password, value: password)

        guard didSaveUser && didSavePassword else {
            return .failure(.storageFailed)
        }

        UserDefaults.standard.set(true, forKey: Keys.loggedIn)
        return .success(())
    }

    @discardableResult
    // Attempts to authenticate the user with the saved local account.
    func login(username: String, password: String) -> Result<Void, AuthError> {
        guard let savedUsername = KeychainService.shared.read(key: Keys.username),
              let savedPassword = KeychainService.shared.read(key: Keys.password) else {
            return .failure(.accountNotFound)
        }

        guard username == savedUsername && password == savedPassword else {
            return .failure(.invalidCredentials)
        }

        UserDefaults.standard.set(true, forKey: Keys.loggedIn)
        return .success(())
    }

    // Clears the logged-in state so the user returns to the login screen.
    func logout() {
        UserDefaults.standard.set(false, forKey: Keys.loggedIn)
    }
}

// AuthError groups related state and behavior for this feature.
enum AuthError: LocalizedError {
    case emptyUsername
    case shortPassword
    case accountNotFound
    case invalidCredentials
    case storageFailed

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Enter a username to continue."
        case .shortPassword:
            return "Password must be at least 4 characters."
        case .accountNotFound:
            return "No account found. Please create one first."
        case .invalidCredentials:
            return "Incorrect username or password."
        case .storageFailed:
            return "Unable to securely store credentials."
        }
    }
}
