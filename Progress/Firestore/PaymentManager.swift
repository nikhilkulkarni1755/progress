//
//  PaymentManager.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 6/6/24.
//
//
import Foundation
import StoreKit

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

class PaymentManager: NSObject, ObservableObject {
    
    //create the element
    @Published var allProducts = [PremiumProduct]()
    
    private let allProductIdentifiers = Set(["com.nsk1755.Progress.premium"])
    
    private var productsRequest: SKProductsRequest?
    private var fetchedProducts = [SKProduct]()
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
//    private var user: DBUser? = nil
    private var userId: String? = nil

    private var completedPurchases = [String]() {
            didSet {
                DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                    
                for index in self.allProducts.indices {
                    self.allProducts[index].isLocked = !self.completedPurchases.contains(self.allProducts[index].id)
                }
            }
        }
    }
    
    override init() {
        super.init()
        
        startObservingPaymentQueue()
        
        fetchProducts { products in
//            print(products)
            self.allProducts = products.map {
                PremiumProduct(product: $0)
            }
        }
    }
    
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    // we wrote this
    func isCompletedPurchasesEmpty() -> Bool {
        return self.completedPurchases.isEmpty
    }
    
    private func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        guard self.productsRequest == nil else { return }
        fetchCompletionHandler = completion
        
        productsRequest = SKProductsRequest(productIdentifiers: allProductIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    private func buy( _ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        purchaseCompletionHandler = completion
        
        let payment = SKPayment(product: product)
        
        SKPaymentQueue.default().add(payment)
    }
}

extension PaymentManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            print("couldn't load products")
            if !invalidProducts.isEmpty {
                print("invalid products found")
            }
            productsRequest = nil
            return
        }
        
        //cache the fetched products
        fetchedProducts = loadedProducts

        //notify anyone waiting on the product load
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productsRequest = nil
        }
    }
}

extension PaymentManager {
    func product(for identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: {
            $0.productIdentifier == identifier
        })
    }
        
    func purchaseProduct(_ product: SKProduct, userId: String) {
        self.userId = userId
        startObservingPaymentQueue()
        buy(product) {
            _ in
        }
    }
}

extension PaymentManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var shouldFinishTransaction = false
//            var isBuying = false
            switch transaction.transactionState {
                
            case .purchased:
                completedPurchases.append(transaction.payment.productIdentifier)
                shouldFinishTransaction = true
                Task {
                    try await verifyAndComplete(transaction: transaction)
                }
//                isBuying = true
            case .restored:
                completedPurchases.append(transaction.payment.productIdentifier)
                shouldFinishTransaction = true
            case .failed:
                shouldFinishTransaction = true
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
            
            if shouldFinishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
            
//            if isBuying {
//                if let buyuser = self.user {
//                    try await UserManager.shared.purchasedPremium(user: buyuser)
//                }
//            }
        }
    }
}

extension PaymentManager {
    func verifyAndComplete(transaction: SKPaymentTransaction) async throws {
        // purchasedPremium(DBUser) { }
        
//        self.user?.isPremium = true
        guard self.userId != nil else { return }
//        if let user = self.userId? {
        try await UserManager.shared.purchasedPremium(userId: self.userId!)
//        }
        
    }
}
