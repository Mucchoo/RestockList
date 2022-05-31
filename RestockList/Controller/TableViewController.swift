//
//  ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import SwiftUI
import StoreKit
import RealmSwift
import RevenueCat

class TableViewController: UITableViewController, EditProtocol, UpdateProtocol {

    private var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate設定
        tableView.delegate = self
        //初回起動時にチュートリアルを表示
        if Data.user.bool(forKey: "tutorial") == false {
            performSegue(withIdentifier: "showTutorial", sender: nil)
            Data.user.set(true, forKey: "tutorial")
        }
        //日付が変わっていた場合アイテムの残り日数を更新
        let realm = Data.realm
        let currentDate = Int(floor(Date().timeIntervalSince1970)/86400)
        if let lastDate = Data.user.object(forKey: "lastDate") as? Int {
            let elapsedDays = currentDate - lastDate
            if elapsedDays > 0 {
                realm.beginWrite()
                for Item in realm.objects(Item.self) {
                    Item.remainingTime -= elapsedDays
                    if Item.remainingTime < 0 {
                        Item.remainingTime = 0
                    }
                }
                try! realm.commitWrite()
            }
        }
        Data.user.set(currentDate, forKey: "lastDate")
        //アプリを20回起動する毎にレビューアラートを表示
        if Data.user.integer(forKey: "launchedTimes") > 20 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                Data.user.set(0, forKey: "launchedTimes")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //テーマカラーの反映
        let theme = Data.user.object(forKey: "theme") ?? 1
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "AccentColor\(theme)")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        //realmからアイテムを取得
        let realm = Data.realm
        items = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        tableView.reloadData()
    }
    //セクションの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //セルの生成
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell") as! TableViewCell
        //delegate設定
        cell.delegate = self
        cell.updateDelegate = self
        //realm情報をアイテムに反映
        cell.itemLabel.text = items[indexPath.row].name
        cell.progressBar.progress = Float(items[indexPath.row].remainingTime) / Float(items[indexPath.row].period)
        //残り期間が半分以上のアイテムと半分以下のアイテムで表示場所を切り替え
        if Float(items[indexPath.row].remainingTime) / Float(items[indexPath.row].period) < 0.5 {
            cell.periodLabelRight.text = "残り\(items[indexPath.row].remainingTime)日"
            cell.periodLabelLeft.text = ""

        } else {
            cell.periodLabelLeft.text = "残り\(items[indexPath.row].remainingTime)日"
            cell.periodLabelRight.text = ""

        }
        //cell内のボタンの判別用タグ設定
        cell.editButton.tag = items[indexPath.row].id
        cell.plusButton.tag = items[indexPath.row].id
        cell.minusButton.tag = items[indexPath.row].id
        cell.checkButton.tag = items[indexPath.row].id
        //テーマカラーを反映
        let theme = Data.user.object(forKey: "theme") ?? 1
        cell.periodFrame.layer.borderColor = UIColor(named: "AccentColor\(theme)")?.cgColor
        cell.progressBar.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.editButton.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.checkButton.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.minusButton.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.plusButton.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.periodLabelRight.textColor = UIColor(named: "AccentColor\(theme)")
        return cell
    }
    //編集ボタンを押したときに押されたアイテムの情報を送信
    func catchData(selectedCell: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextStoryboard = storyboard.instantiateViewController(withIdentifier: "EditStoryboard") as! EditViewController
        nextStoryboard.selectedCell = selectedCell
        self.show(nextStoryboard, sender: self)
    }
    //cell内のボタンを押したときにTableViewを更新
    func updateTableView() {
        tableView.reloadData()
    }
    //アイテム追加アクション
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        if items.count > 19 {
            //内課金購入状態を取得
            var isPro = false
            Purchases.shared.getCustomerInfo { customerInfo, error in
                guard error == nil else {
                    print("内課金状態取得時のエラー\(error!)")
                    return
                }
                if customerInfo?.entitlements["Pro"]?.isActive == true {
                    isPro = true
                }
            }
            //非課金ユーザーは20個以上登録できない
            if isPro {
                performSegue(withIdentifier: "AddSegue", sender: nil)
            } else {
                let alert = UIAlertController(title: "無料版で追加できるアイテムは20個です", message: "Proにアップグレードすれば、無制限に追加することができます。", preferredStyle:  UIAlertController.Style.alert)
                let proAction = UIAlertAction(title: "Proを見る", style: .default) { action in
                    self.performSegue(withIdentifier: "ProFromTopSegue", sender: nil)
                }
                let closeAction = UIAlertAction(title: "閉じる", style: .default)
                alert.addAction(closeAction)
                alert.addAction(proAction)
                present(alert, animated: true)
            }
        } else {
            performSegue(withIdentifier: "AddSegue", sender: nil)
        }
    }
}
