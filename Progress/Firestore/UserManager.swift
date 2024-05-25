//
//  UserManager.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/24/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let isPremium: Bool
    let progress: Int?
    let dateCreated: Date?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData = [String:Any] = [
            
        ]
        
        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//        Firestore.firestore().collection("users").document(userId).setData(<#T##documentData: [String : Any]##[String : Any]#>)
    }
}
