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
    static func purchase(view: UIViewController) {
        let loadingView = UIView(frame: UIScreen.main.bounds)
        LoadModel.showLoading(to: loadingView)
        Purchases.shared.getOfferings { (offerings, error) in
            guard error == nil else {
                print("offerings取得時のエラー\(error!)")
                loadingView.removeFromSuperview()
                return
            }
            guard let package = offerings?.current?.lifetime?.storeProduct else {
                print("product取得時のエラー\(error!)")
                loadingView.removeFromSuperview()
                return
            }
            Purchases.shared.purchase(product: package) { (transaction, customerInfo, error, userCancelled) in
                loadingView.removeFromSuperview()
                guard error == nil else {
                    print("内課金購入時のエラー\(error!)")
                    return
                }
                if customerInfo?.entitlements["Pro"]?.isActive == true {
                    let alert = UIAlertController(title: "購入しました", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        view.navigationController?.popToRootViewController(animated: true)
                    })
                    view.present(alert, animated: true)
                }
            }
        }
    }
    //内課金復元
    static func restore(view: UIViewController) {
        let loadingView = UIView(frame: UIScreen.main.bounds)
        LoadModel.showLoading(to: loadingView)
        Purchases.shared.restorePurchases { customerInfo, error in
            loadingView.removeFromSuperview()
            guard error == nil else {
                print("内課金復元時のエラー\(error!)")
                return
            }
            if customerInfo?.entitlements["Pro"]?.isActive == true {
                let alert = UIAlertController(title: "購入を復元しました", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    view.navigationController?.popToRootViewController(animated: true)
                })
                view.present(alert, animated: true)
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
