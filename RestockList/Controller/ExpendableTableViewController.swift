//
//  ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import StoreKit
import RealmSwift
//アイテム編集ボタンを押した時にcellを判別する
protocol EditProtocol {
    func catchData(selectedCell: Int)
}
//cell内のボタンからTableViewを更新
protocol UpdateProtocol {
    func updateTableView()
}

class ExpendableTableViewController: UITableViewController, EditProtocol, UpdateProtocol {

    private var expendables = [Expendable]()
    private var storeModel = StoreModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView設定
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        //初回起動時にチュートリアルを表示
        if DataModel.user.bool(forKey: R.string.localizable.tutorial()) == false {
            performSegue(withIdentifier: R.string.localizable.showTutorial(), sender: nil)
            DataModel.user.set(true, forKey: R.string.localizable.tutorial())
        }
        //日付が変わっていた場合アイテムの残り日数を更新
        RealmModel.reflectElapsedDays()
        //アプリを20回起動する毎にレビューアラートを表示
        if DataModel.user.integer(forKey: R.string.localizable.launchedTimes()) > 20 {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            SKStoreReviewController.requestReview(in: scene)
            DataModel.user.set(0, forKey: R.string.localizable.launchedTimes())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = ThemeModel.color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        //realmからアイテムを取得
        expendables = RealmModel.expendables
        tableView.reloadData()
    }
    //セクションの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expendables.count
    }
    //セルの生成
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.reusableCell, for: indexPath)!
        //delegate設定
        cell.editDelegate = self
        cell.updateDelegate = self
        //realm情報をアイテムに反映
        cell.expendableLabel.text = expendables[indexPath.row].name
        cell.progressBar.progress = Float(expendables[indexPath.row].remainingTime) / Float(expendables[indexPath.row].period)
        //残り期間が半分あるかどうかで残り日数の場所を切り替え
        if Float(expendables[indexPath.row].remainingTime) / Float(expendables[indexPath.row].period) < 0.5 {
            cell.periodLabelRight.text = R.string.localizable.remain() + String(expendables[indexPath.row].remainingTime) + R.string.localizable.day()
            cell.periodLabelLeft.text = ""

        } else {
            cell.periodLabelLeft.text = R.string.localizable.remain() + String(expendables[indexPath.row].remainingTime) + R.string.localizable.day()
            cell.periodLabelRight.text = ""

        }
        //cell内のボタンの判別用タグ設定
        cell.editButton.tag = expendables[indexPath.row].id
        cell.plusButton.tag = expendables[indexPath.row].id
        cell.minusButton.tag = expendables[indexPath.row].id
        cell.checkButton.tag = expendables[indexPath.row].id
        //テーマカラーを反映
        cell.periodFrame.layer.borderColor = ThemeModel.color.cgColor
        cell.progressBar.tintColor = ThemeModel.color
        cell.editButton.tintColor = ThemeModel.color
        cell.checkButton.tintColor = ThemeModel.color
        cell.minusButton.tintColor = ThemeModel.color
        cell.plusButton.tintColor = ThemeModel.color
        cell.periodLabelRight.textColor = ThemeModel.color
        return cell
    }
    //編集ボタンを押したときに押されたアイテムの情報を送信
    func catchData(selectedCell: Int) {
        let storyboard = R.storyboard.main()
        let nextStoryboard = storyboard.instantiateViewController(withIdentifier: R.string.localizable.editStoryboard()) as! EditViewController
        nextStoryboard.selectedCell = selectedCell
        self.show(nextStoryboard, sender: self)
    }
    //cell内のボタンを押したときにTableViewを更新
    func updateTableView() {
        tableView.reloadData()
    }
    //アイテム追加アクション
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        if expendables.count > 19 {
            //非課金ユーザーは20個以上登録できない
            if DataModel.user.bool(forKey: R.string.localizable.purchaseStatus()) {
                performSegue(withIdentifier: R.string.localizable.addSegue(), sender: nil)
            } else {
                let alert = UIAlertController(title: R.string.localizable.twentyItemsAvailableInFree(), message: R.string.localizable.unlimitedIfJoinPro(), preferredStyle:  UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: R.string.localizable.close(), style: .default))
                alert.addAction(UIAlertAction(title: R.string.localizable.seePro(), style: .default) { action in
                    self.performSegue(withIdentifier: R.string.localizable.proFromTopSegue(), sender: nil)
                })
                present(alert, animated: true)
            }
        } else {
            performSegue(withIdentifier: R.string.localizable.addSegue(), sender: nil)
        }
    }
    //設定画面に遷移
    @IBAction func settingAction(_ sender: UIBarButtonItem) {
        let storyboard = R.storyboard.settingView()
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: R.string.localizable.settingView())
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
}
