//
//  PurchaseManager.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 6/5/24.
//

import Foundation
import StoreKit

final class PurchaseManager: ObservableObject {
    
    
    @Published var purchasedItems: [Product] = []
    @Published var storeProducts: [Product] = []
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    // MY CODE
//    static let shared = PurchaseManager()
//    private init() {
//        Task {
//            try await requestProducts()
//            updateListenerTask = listenForTransactions()
//        }
//    }
//    private let productDict: [String: String]
    init() {
        
        // key, string
        
        // i don't need the productDict
        
        updateListenerTask = listenForTransactions()
        
        Task {
            try await requestProducts()
            try await updateProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached{
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    await self.updateProductStatus()
                    
                    await transaction.finish()
                }
                catch {
                    print("transaction failed verification")
                }
            }
        }
    }
    
//    private let productDict: [String: String]
    
//    func requestProducts() async throws -> [Product] {
    func requestProducts() async {
        do {
            self.storeProducts = try await Product.products(for: ["com.nsk1755.Progress.premium"])
//            return try await Product.products(for: ["com.nsk1755.Progress.premium"])
        } catch {
            print("Error retrieving product")
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let signedType):
            return signedType
        }
    }
    
    @MainActor
    func updateProductStatus() async {
        var purchased: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                if let item = storeProducts.first(where: {$0.id == transaction.productID}) {
                    purchased.append(item)
                }
            } catch {
                print("Transaction failed verification")
            }
            
            self.purchasedItems = purchased
        }
    }
    
//    func purchase(user: DBUser, product: Product) async throws -> Transaction? {
    func purchase(user: DBUser, product: Product) async throws -> Transaction? {
//        let product = try await Product.products(for: ["com.nsk1755.Progress.premium"])
        let result = try await product.purchase()
        
        switch result {
        case .success(let verificationResult):
            let transaction = try checkVerified(verificationResult)
            
            await updateProductStatus()
            
            //this is our addition for firebase yay
            try await UserManager.shared.purchasedPremium(user: user)
            
            await transaction.finish()
            
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func isPurchased(product: Product) async throws -> Bool {
        return purchasedItems.contains(product)
    }
    
    // this connects to profile view
    func getProducts() async throws -> [Product] {
        
        do {
            return try await Product.products(for: ["com.nsk1755.Progress.premium"])
//            return try await Product.products(for: ["com.nsk1755.Progress.premium"])
        } catch {
            
        }
        
        return []
    }
    
    
    
    
}

public enum StoreError: Error {
    case failedVerification
}
