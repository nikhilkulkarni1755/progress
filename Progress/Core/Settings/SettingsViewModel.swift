//
//  SettingsViewModel.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/24/24.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
//    func resetPassword() async throws {
//        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
//        guard let email = authUser.email else {
//            throw URLError(.fileDoesNotExist)
//        }
//        
//        try await AuthenticationManager.shared.resetPassword(email: email)
//    }
}
