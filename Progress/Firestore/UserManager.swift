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
    let userId: String?
    let isPremium: Bool?
    let email: String?
    let progress: Int?
    let dateCreated: Date?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
//    private let userCollection = Firestore.firestore().collection("users")
//    
//    private func userDocument(userId: String) -> DocumentReference {
//        userCollection.document(userId)
//    }
    
    
    
//    func createNewUser(user: DBUser) async throws {
//        try await userDocument(userId: user.userId).setData(from: user, merge: false)
//        Firestore.firestore().collection("users").document(userId).setData(<#T##documentData: [String : Any]##[String : Any]#>)
//    }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String:Any] = [
            "user_id": auth.uid,
//            "progress": auth.progress?,
        ]
        userData["date_created"] = Timestamp()
        
        userData["is_premium"] = false
        if let email = auth.email {
            userData["email"] = email
        }
        userData["progress"] = 0
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data() else {
            throw URLError(.badServerResponse)
        }
        
        let userId = data["user_id"] as? String
        let dateCreated = data["date_created"] as? Date
        let email = data["email"] as? String
        let isPremium = data["is_premium"] as? Bool
        let progress = data["progress"] as? Int
        
        return DBUser(userId: userId, isPremium: isPremium, email: email, progress: progress, dateCreated: dateCreated)
    }
}
