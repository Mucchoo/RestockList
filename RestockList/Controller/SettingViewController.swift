//
//  SettingViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/27.
//

import UIKit
import StoreKit
import MessageUI

class SettingViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var iconBackground: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconBackground.forEach{ $0.layer.cornerRadius = 8}
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        sender.backgroundColor = UIColor(.black.opacity(0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor = UIColor(.black.opacity(0))
        }
        let link = URL(string: "https://www.google.com")!
        let activityViewController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let rootVC = windowScenes?.keyWindow?.rootViewController
        rootVC?.present(activityViewController, animated: true, completion: nil)
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
        let toRecipients = ["yazujumusa@gmail.com"]
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("ご意見・ご要望")
        mailViewController.setToRecipients(toRecipients) //Toアドレスの表示
        mailViewController.setMessageBody("メールの本文", isHTML: false)
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
