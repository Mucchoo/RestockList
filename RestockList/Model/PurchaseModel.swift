//
//  PurchaseModel.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/06/07.
//

import UIKit
import RevenueCat

struct PurchaseModel {
    //内課金購入
    static func purchase() {
        Purchases.shared.getOfferings { (offerings, error) in
            guard error == nil else {
                print("offerings取得時のエラー\(error!)")
                return
            }
            guard let package = offerings?.current?.lifetime?.storeProduct else { return }
            Purchases.shared.purchase(product: package) { (transaction, customerInfo, error, userCancelled) in
                guard error == nil else {
                    print("内課金購入時のエラー\(error!)")
                    return
                }
            }
        }
    }
    //内課金復元
    static func restore() {
        Purchases.shared.restorePurchases { customerInfo, error in
            guard error == nil else {
                print("内課金復元時のエラー\(error!)")
                return
            }
        }
    }
    //内課金状態
    static var status: Bool {
        var isPro = false
        Purchases.shared.getCustomerInfo { customerInfo, error in
            guard error == nil else {
                print("内課金状態取得時のエラー\(error!)")
                return
            }
            isPro = customerInfo?.entitlements["Pro"]?.isActive == true
        }
        return isPro
    }
}
