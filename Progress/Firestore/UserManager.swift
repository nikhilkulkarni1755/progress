//
//  UserManager.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 5/24/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
//import StoreKit

struct Activity: Codable {
//    let activityNumber: Int?
    let dateLastUpdated: Date?
    let name: String?
    let progress: Int?
}

struct DBUser: Codable {
    
    let userId: String
    let isPremium: Bool?
    let email: String?
//    let progress: Int?
    let dateCreated: Date?
//    let activities: [Activity]?
    
    
//    init(auth: AuthDataResultModel) {
//        self.userId = auth.uid
//        self.isPremium = auth.
//        self.userId = auth.uid
//        self.userId = auth.uid
//        self.userId = auth.uid
//    }
}

final class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")

    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func activitiesDocument(userId: String) -> CollectionReference {
        userCollection.document(userId).collection("activities")
    }
    
//    private func getActivities() {
//        private let activityCollection = Firestore.firestore().collection("users").getDocuments(userId).collection("")
//    }
//    func getActivities(user: DBUser) async throws {
//        let results: [Activity] = [
//            activitiesDocument(user.userId).document("activity_1"),
//            activitiesDocument(user.userId).document("activity_2"),
//            activitiesDocument(user.userId).document("activity_3"),
//        ]
//        
//    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false, encoder: encoder)
    }
    
    func createNewActivities(user: DBUser) async throws {
        let name = ""
        let data: [String:Any] = [
            "name": name,
            "date_last_updated": Timestamp(),
            "progress": 0
        ]
        try await userDocument(userId: user.userId).collection("activities").document("activity_1").setData(data, merge: false)
        try await userDocument(userId: user.userId).collection("activities").document("activity_2").setData(data, merge: false)
        try await userDocument(userId: user.userId).collection("activities").document("activity_3").setData(data, merge: false)
    }
    
    func editActivity(user: DBUser, activity: String, name: String) async throws {
        let data: [String:Any] = [
            "name": name,
            "date_last_updated": Timestamp(),
            "progress": 0
        ]
        try await userDocument(userId: user.userId).collection("activities").document(activity).setData(data, merge: false)
    }
    
    
    
//    func createNewUser(user: DBUser) async throws {
//        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//        
//    }
    
//    func createNewUser(auth: AuthDataResultModel) async throws {
//        var userData: [String:Any] = [
//            "user_id": auth.uid,
////            "progress": auth.progress?,
//        ]
//        userData["date_created"] = Timestamp()
//        
//        userData["is_premium"] = false
//        if let email = auth.email {
//            userData["email"] = email
//        }
//        userData["progress"] = 0
//        
////        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
//        
//        try await userDocument(userId: auth.uid).setData(userData, merge: false)
//    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self, decoder: decoder)
    }
    
    func updateUserPremiumStatus(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
    }
    
//    func updateProgress(user: DBUser) async throws {
//        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
//    }
    
    func addMainActivity(userId: String, name: String) async throws {
        let name = "coding"
        let data: [String:Any] = [
            "name": name,
            "date_last_updated": Timestamp(),
            "progress": 0
        ]
        try await userDocument(userId: userId).collection("activities").document("activity_1").setData(data, merge: false)
    }
    
    func getAllActivities(userId: String) async throws -> [Activity] {
        let snapshot = try await userDocument(userId: userId).collection("activities").getDocuments()
        
        var activities: [Activity] = []
        
        for document in snapshot.documents {
            let act = try document.data(as: Activity.self)
            activities.append(act)
        }
        
        return activities
    }
    
    func getMainActivity(userId: String) async throws -> Activity {
        try await userDocument(userId: userId).collection("activities").document("activity_1").getDocument(as: Activity.self, decoder: decoder)
    }
    
    func getSecondActivity(userId: String) async throws -> Activity {
        
        try await userDocument(userId: userId).collection("activities").document("activity_2").getDocument(as: Activity.self, decoder: decoder)
//        result.append(try await userDocument(userId: userId).collection("activities").document("activity_3").getDocument(as: Activity.self, decoder: decoder))
        
//        result.append(/*activity_2*/)
//        result.append(activity_3)
//        return result
    }
    
    func getThirdActivity(userId: String) async throws -> Activity {
        
        try await userDocument(userId: userId).collection("activities").document("activity_3").getDocument(as: Activity.self, decoder: decoder)
    }
    
    func updateProgress(user: String, activity: Activity, id: String) async throws {
//        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
//        try userDocument(userId: user.userId).collection("activities").document(id).setData(activity, merge: false) //(id).setData()
        try userDocument(userId: user).collection("activities").document(id).setData(from: activity, merge: true, encoder: encoder)
    }
    
//    func getActivities(user: DBUser) async throws {
//        try userDocument(userId: user.userId).setData(from: user, merge: true, encoder: encoder)
//    }
    
//    func getUser(userId: String) async throws -> DBUser {
////        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
//        let snapshot = try await userDocument(userId: userId).getDocument()
//        
//        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//        
////        let userId = data["user_id"] as String
//        let dateCreated = data["date_created"] as? Date
//        let email = data["email"] as? String
//        let isPremium = data["is_premium"] as? Bool
//        let progress = data["progress"] as? Int
//        
//        return DBUser(userId: userId, isPremium: isPremium, email: email, progress: progress, dateCreated: dateCreated)
//    }
}
