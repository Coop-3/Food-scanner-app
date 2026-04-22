// LoginView.swift
//
// Login and account creation screen for the local-first authentication flow.
// Added comments explain the purpose of the file and the role of important members.

import SwiftUI

// LoginView groups related state and behavior for this feature.
struct LoginView: View {
    // Shared authentication state for login/logout flows.
    @EnvironmentObject private var authViewModel: AuthViewModel

    // Builds the SwiftUI interface for this screen or reusable component.
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                VStack(spacing: 10) {
                    Image(systemName: "leaf.circle.fill")
                        .font(.system(size: 68))
                        .foregroundStyle(.green)
                    Text("ExpiTrack")
                        .font(.largeTitle.bold())
                    Text("Track food expiration dates and reduce waste.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                VStack(spacing: 14) {
                    TextField("Username", text: $authViewModel.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    SecureField("Password", text: $authViewModel.password)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }

                Button(action: authViewModel.submit) {
                    Text(authViewModel.isCreateAccountMode || !AuthService.shared.hasAccount() ? "Create Account" : "Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button(authViewModel.isCreateAccountMode ? "Already have an account? Log In" : "Need an account? Create One") {
                    authViewModel.isCreateAccountMode.toggle()
                    authViewModel.errorMessage = ""
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(24)
            .background(Color(.systemBackground))
        }
    }
}
