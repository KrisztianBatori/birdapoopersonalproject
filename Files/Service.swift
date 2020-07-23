//
//  Service.swift
//  Bird-A-Poo
//
//  Created by Báthory Krisztián on 2019. 05. 26..
//  Copyright © 2019. Golden Games. All rights reserved.
//

import Foundation
import StoreKit

class Service: NSObject {
    
    private override init() {}
    static let sharedService = Service()
    var product = SKProduct()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProduct() {
        let product: Set = [Product.appFullVersion.rawValue]
        let request = SKProductsRequest(productIdentifiers: product)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchaseProduct() {
        paymentQueue.add(SKPayment(product: product))
    }
}

extension Service: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.product = response.products.first!
        BuyMenu.productReceived = true
    }
    
}

extension Service: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
                case .purchasing: break
                case .purchased: GameViewController.fullVersionEnabled = true
                fallthrough
            default: queue.finishTransaction(transaction); BuyMenu.transactionEnded = true
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
            case .deferred: return "deferred"
            case.failed: return "failed"
            case.purchased: return "purchased"
            case.purchasing: return "purchasing"
            case.restored: return "restored"
        }
    }
}

extension SKProduct {
    
    var localizedPrice: String? {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.locale = priceLocale
        numberFormatter.numberStyle = .currency
        
        return numberFormatter.string(from: price)
    }
    
}
