//
//  PaymentManager.swift
//  Progress
//
//  Created by Nikhil Kulkarni on 6/6/24.
//

import Foundation
import StoreKit

class PaymentManager: NSObject, ObservableObject, SKPaymentTransactionObserver {
    static let shared = PaymentManager()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func paymentQueue( _ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Transaction successed! \(transaction)")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Transaction failed! \(transaction)")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("Transaction failed! \(transaction)")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
            
        }
    }
}
