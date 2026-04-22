// UserAccount.swift
//
// Simple account model used for local authentication data.
// Added comments explain the purpose of the file and the role of important members.

import Foundation

// UserAccount groups related state and behavior for this feature.
struct UserAccount: Codable, Equatable {
    // Bound username field used on the login screen.
    var username: String
    // Bound password field used on the login screen.
    var password: String
}
