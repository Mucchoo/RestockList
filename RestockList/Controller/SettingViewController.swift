//
//  SettingViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/27.
//

import UIKit
import StoreKit
import MessageUI
import RevenueCat

class SettingViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var iconBackground: [UIView]!
    @IBOutlet weak var themeView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var proLabel: UILabel!
    private var isPro = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconBackground.forEach{ $0.layer.cornerRadius = 8}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        iconBackground.forEach{ $0.backgroundColor = UIColor(named: "AccentColor\(theme)") }
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if customerInfo?.entitlements["Pro"]?.isActive == true {
                self.isPro = true
            }
        }
        if isPro {
            proLabel.text = "Pro アンロック済み"
            themeView.layer.opacity = 1
            iconView.layer.opacity = 1
        } else {
            themeView.layer.opacity = 0.5
            iconView.layer.opacity = 0.5
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func proButtonTapped(_ sender: UIButton) {
        if isPro == false {
            performSegue(withIdentifier: "ProSegue", sender: nil)
        }
    }
    
    @IBAction func themeButtonTapped(_ sender: UIButton) {
        if isPro {
            performSegue(withIdentifier: "ThemeSegue", sender: nil)
        }
    }
    
    @IBAction func iconButtonTapped(_ sender: UIButton) {
        if isPro {
            performSegue(withIdentifier: "IconSegue", sender: nil)
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = UIColor(.black.opacity(0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor = UIColor(.black.opacity(0))
        }
        let link = URL(string: "https://apps.apple.com/us/app/%E6%B6%88%E8%80%97%E5%93%81%E3%83%AA%E3%82%B9%E3%83%88-%E5%AE%9A%E6%9C%9F%E7%9A%84%E3%81%AB%E8%B3%BC%E5%85%A5%E3%81%99%E3%82%8B%E7%94%9F%E6%B4%BB-%E4%BA%8B%E5%8B%99%E7%94%A8%E5%93%81%E3%81%AE%E7%AE%A1%E7%90%86/id1622760822?itsct=apps_box_link&itscg=30200")!
        let av = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.keyWindow
        window?.rootViewController?.present(av, animated: true, completion: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            av.popoverPresentationController?.sourceView = window
            av.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width/2.1, y: UIScreen.main.bounds.height/1.3, width: 200, height: 200)
        }
    }
    
    @IBAction func reviewButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = UIColor(.black.opacity(0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor = UIColor(.black.opacity(0))
        }
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = UIColor(.black.opacity(0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor = UIColor(.black.opacity(0))
        }
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("ご意見・ご要望")
        mailViewController.setToRecipients(["yazujumusa@gmail.com"])
        mailViewController.setMessageBody("\n\n\n\n\nーーーーーーーーーーーーーーー\nこの上へお気軽にご記入ください。\n消耗品リスト", isHTML: false)
        present(mailViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "メールを送信しました", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        } else if result == .failed {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "メールの送信に失敗しました", message: "時間を置いてからもう一度お試しください。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
