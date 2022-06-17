//
//  SettingViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/27.
//

import UIKit
import MessageUI

class SettingTableViewController: UITableViewController {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var proLabel: UILabel!
    @IBOutlet weak var themeView: UIView!
    @IBOutlet var iconBackground: [UIView]!
    
    private var storeModel = StoreModel()
    private var purchaseStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI調整
        iconBackground.forEach{ $0.layer.cornerRadius = 8 }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //テーマカラー反映
        iconBackground.forEach{ $0.backgroundColor = ThemeModel.color }
        //課金状態で表示内容を変更
        purchaseStatus = DataModel.user.bool(forKey: R.string.localizable.purchaseStatus())
        if purchaseStatus {
            self.proLabel.text = R.string.localizable.unlockedPro()
            self.themeView.layer.opacity = 1
            self.iconView.layer.opacity = 1
        } else {
            themeView.layer.opacity = 0.5
            iconView.layer.opacity = 0.5
        }
    }
    //cell選択時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Proセクション
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0://Proをアンロック
                if !purchaseStatus { performSegue(withIdentifier: R.string.localizable.proSegue(), sender: nil) }
            case 1://テーマカラー
                performSegue(withIdentifier: R.string.localizable.themeSegue(), sender: nil)
            case 2://アイコン
                performSegue(withIdentifier: R.string.localizable.iconSegue(), sender: nil)
            default: return
            }
        //アプリケーションセクション
        } else {
            switch indexPath.row {
            case 0://使い方
                performSegue(withIdentifier: R.string.localizable.tutorialSegue(), sender: nil)
            case 1://通知設定
                performSegue(withIdentifier: R.string.localizable.notificationSegue(), sender: nil)
            case 2://アプリをシェア
                let link = URL(string: R.string.localizable.appURL())!
                let av = UIActivityViewController(activityItems: [link], applicationActivities: nil)
                let scenes = UIApplication.shared.connectedScenes
                let windowScenes = scenes.first as? UIWindowScene
                let window = windowScenes?.keyWindow
                window?.rootViewController?.present(av, animated: true, completion: nil)
            case 3://ご意見・ご要望
                showEmail()
            default: return
            }
        }
        //背景が黒くなるのをすぐに戻す
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//メール関連
extension SettingTableViewController: MFMailComposeViewControllerDelegate {
    //メールフォームを表示
    private func showEmail() {
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject(R.string.localizable.messageSubject())
        mailViewController.setToRecipients([R.string.localizable.messageRecipient()])
        mailViewController.setMessageBody(R.string.localizable.messageBody(), isHTML: false)
        present(mailViewController, animated: true, completion: nil)
    }
    //メールフォームを閉じた後の処理
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if result == .sent {
            let alert = UIAlertController(title: R.string.localizable.sendEmail(), message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
            present(alert, animated: true)
        } else if result == .failed {
            let alert = UIAlertController(title: R.string.localizable.cannotSendEmail(), message: R.string.localizable.tryAgain(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.localizable.ok(), style: .default))
            present(alert, animated: true)
        }
    }
}
