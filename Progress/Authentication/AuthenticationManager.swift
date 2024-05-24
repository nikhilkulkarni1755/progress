//
//  AuthenticationManager.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/22/24.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
//    let photoUrl: String?
    
    init(user:User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    // singleton design not scalable for larger projects
    static let shared = AuthenticationManager()
    
    private init() {}
    
    @discardableResult
    func createUser(email:String, password: String) async throws -> AuthDataResultModel {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        return AuthDataResultModel(
            user: authResult.user
            
            /*uid: authResult.user.uid, email: authResult.user.email*/
//                                         , photoUrl: authResult.user.photoURL
        )
    }
    
    // this function is not going to server, hence no async.
    // this should use localstorage to find the authenticated user
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    @discardableResult
    func signInUser(email:String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(
            user: authDataResult.user
        )
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    
}
