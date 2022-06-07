//
//  ProViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/02.
//

import UIKit
import RevenueCat

class ProViewController: UIViewController {

    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet var iconBackground: [UIView]!
    @IBOutlet var productImage: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI調整
        iconBackground.forEach{ $0.layer.cornerRadius = 15 }
        productImage.forEach{ $0.layer.cornerRadius = 20 }
        purchaseButton.layer.cornerRadius = 20
        restoreButton.layer.cornerRadius = 20
        purchaseButton.setShadow()
        restoreButton.setShadow()
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        iconBackground.forEach{ $0.backgroundColor = themeModel.color }
        purchaseButton.backgroundColor = themeModel.color
    }
    //内課金アイテムを購入
    @IBAction func purchaseAction(_ sender: UIButton) {
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
                if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    //購入した内課金アイテムを復元
    @IBAction func restoreAction(_ sender: UIButton) {
        Purchases.shared.restorePurchases { customerInfo, error in
            guard error == nil else {
                print("内課金復元時のエラー\(error!)")
                return
            }
            guard !(customerInfo?.entitlements.all["Pro"]?.isActive)! else { return }
            let alert = UIAlertController(title: "購入を復元しました", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            })
            self.present(alert, animated: true)
        }
    }
}
