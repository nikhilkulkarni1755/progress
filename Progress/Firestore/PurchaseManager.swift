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
    static let shared = PurchaseManager()
    private init() {
//        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
            await updateProductStatus()
        }
    }
//    private let productDict: [String: String]

//    TUTORIAL CODE
//    init() {
//
//        // key, string
//        
//        // i don't need the productDict
//        
//        updateListenerTask = listenForTransactions()
//        
//        Task {
//            await requestProducts()
//            await updateProductStatus()
//        }
//    }
    
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
        let mainproduct = try await Product.products(for: ["com.nsk1755.Progress.premium"])
        
        if let prod = mainproduct.first {
            print("\(prod.displayPrice)")
            let result = try await prod.purchase()
            print(result)
            switch result {
            case .success(let verificationResult):
                let transaction = try checkVerified(verificationResult)
                print(transaction)
//                await updateProductStatus()
                
                //this is our addition for firebase yay
                if self.purchasedItems != [] {
                    print("self.purchasedItems is not empty")
                    print(self.purchasedItems)
                }
                else {
                    print("self.purchasedItems is empty")
                }
//                commenting out so I can reuse Accounts lmfao
                
                
                await transaction.finish()
                
                await updateProductStatus()
                
                print("done awaiting transaction finish")
                
//                try await UserManager.shared.purchasedPremium(user: user)
                
                return transaction
            case .userCancelled, .pending:
                return nil
            default:
                return nil
            }
        }
        else {
            print("prod is empty")
        }
        return nil
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
