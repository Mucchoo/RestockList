//
//  ProViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/02.
//

import UIKit
import RevenueCat

class ProViewController: UIViewController {

    @IBOutlet var iconBackground: [UIView]!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet var image: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconBackground.forEach{ $0.layer.cornerRadius = 15}
        button.layer.cornerRadius = 20
        restoreButton.layer.cornerRadius = 20
        image.forEach{ $0.layer.cornerRadius = 20 }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        iconBackground.forEach{ $0.backgroundColor = UIColor(named: "AccentColor\(theme)") }
        button.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
    
    @IBAction func ButtonTapped(_ sender: UIButton) {
        print("ボタンタップ発動")
        Purchases.shared.getOfferings { (offerings, error) in
            if let package = offerings?.current?.lifetime?.storeProduct {
                Purchases.shared.purchase(product: package) { (transaction, customerInfo, error, userCancelled) in
                    if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func restoreButtonTapped(_ sender: UIButton) {
        Purchases.shared.restorePurchases { customerInfo, error in
            if customerInfo?.entitlements.all["Pro"]?.isActive == true {
                let alert = UIAlertController(title: "購入を復元しました", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                self.present(alert, animated: true)
            }
        }
    }
}
