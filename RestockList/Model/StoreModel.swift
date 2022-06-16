//
//  PurchaseModel.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/06/07.
//

import UIKit
import StoreKit

class StoreModel: NSObject {
    
    var products = [SKProduct]()
    //初期設定
    func setup() {
        let request = SKProductsRequest(productIdentifiers: [R.string.localizable.pro()])
        request.delegate = self
        request.start()
    }
    //購入
    func purchase() {
        guard let product = products.first else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    //復元
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
        SKPaymentQueue.default().add(self)
    }
    //購入後のアラート
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: R.string.localizable.unlockedAllFeatures(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
        WindowModel.window.rootViewController?.present(alert, animated: true)
    }
}
//情報取得後
extension StoreModel: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }
}
// transactions変更時
extension StoreModel: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .purchasing: print("purchasing")
            case .purchased:
                print("purchased")
                DataModel.user.set(true, forKey: R.string.localizable.purchaseStatus())
                showAlert(title: R.string.localizable.purchased())
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                print("restored")
                DataModel.user.set(true, forKey: R.string.localizable.purchaseStatus())
                showAlert(title: R.string.localizable.restored())
                SKPaymentQueue.default().finishTransaction($0)
            case .deferred: print("defferred")
            case .failed:
                print("failed")
                SKPaymentQueue.default().finishTransaction($0)
            default: break
            }
        }
    }
}
