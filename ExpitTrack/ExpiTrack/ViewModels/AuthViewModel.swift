// AuthViewModel.swift
//
// View model for the login screen. Stores form state, submits authentication actions, and exposes error messages to the UI.
// Added comments explain the purpose of the file and the role of important members.

import Foundation
import Combine

@MainActor
// AuthViewModel groups related state and behavior for this feature.
final class AuthViewModel: ObservableObject {
    // Bound username field used on the login screen.
    @Published var username = ""
    // Bound password field used on the login screen.
    @Published var password = ""
    // Boolean app-login state observed by the root view.
    @Published var isLoggedIn = false
    // User-facing authentication error message.
    @Published var errorMessage = ""
    // Switches the login screen between create-account and login behavior.
    @Published var isCreateAccountMode = false

    private let authService = AuthService.shared

    // Initializes the type and prepares any starting state the app needs.
    init() {
        isLoggedIn = authService.isLoggedIn()
    }

    // Submits the login or sign-up action based on the current screen mode.
    func submit() {
        errorMessage = ""
        let result: Result<Void, AuthError>

        if isCreateAccountMode || !authService.hasAccount() {
            result = authService.signUp(username: username, password: password)
        } else {
            result = authService.login(username: username, password: password)
        }

        switch result {
        case .success:
            isLoggedIn = true
            username = ""
            password = ""
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }

    // Clears the logged-in state so the user returns to the login screen.
    func logout() {
        authService.logout()
        isLoggedIn = false
    }
}
