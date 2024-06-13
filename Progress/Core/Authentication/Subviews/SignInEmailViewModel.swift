//
//  SignInEmailViewModel.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/24/24.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        
        //validation
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        /*
         let userId: String
         let isPremium: Bool
         let progress: Int?
         let dateCreated: Date?
         */
//        let user = DBUser(userId: authDataResult.uid, isPremium: , progress: , dateCreated: )
//        try await UserManager.shared.createNewUser(auth: authDataResult)
        let dbuser = DBUser(userId: authDataResult.uid, isPremium: false, email: authDataResult.email, dateCreated: Date())
        try await UserManager.shared.createNewUser(user: dbuser)
        try await UserManager.shared.createNewActivities(user: dbuser)
        
    }
    
    func signIn() async throws {
        
        //validation
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
    }
    
    func resetPassword() async throws {
//        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard !email.isEmpty else { return }
//        guard let email = authUser.email else {
//            throw URLError(.fileDoesNotExist)
//        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
}
