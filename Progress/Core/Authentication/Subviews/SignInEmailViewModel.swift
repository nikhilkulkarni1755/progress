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
        try await UserManager.shared.createNewUser(auth: authDataResult)
        
    }
    
    func signIn() async throws {
        
        //validation
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        
    }
}
