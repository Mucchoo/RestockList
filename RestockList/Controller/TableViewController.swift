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
    
    @IBOutlet var myTableView: UITableView!
    private var data = [Item]()
    private var isPro = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        let realm = r.realm
        let currentDate = Int(floor(Date().timeIntervalSince1970)/86400)
        if let lastDate = r.user.object(forKey: "lastDate") as? Int {
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
        r.user.set(currentDate, forKey: "lastDate")
        if r.user.bool(forKey: "tutorial") == false {
            performSegue(withIdentifier: "showTutorial", sender: nil)
            r.user.set(true, forKey: "tutorial")
        }
        
        if r.user.integer(forKey: "LaunchedTimes") > 20 {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                r.user.set(0, forKey: "LaunchedTimes")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if customerInfo?.entitlements["Pro"]?.isActive == true {
                self.isPro = true
            }
        }
        let realm = r.realm
        data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        let theme = r.user.object(forKey: "theme") ?? 1
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "AccentColor\(theme)")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        tableView.reloadData()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell") as! TableViewCell
        cell.itemLabel.text = data[indexPath.row].name
        cell.progressBar.progress = Float(data[indexPath.row].remainingTime) / Float(data[indexPath.row].period)
        if Float(data[indexPath.row].remainingTime) / Float(data[indexPath.row].period) < 0.5 {
            cell.periodLabelRight.text = "残り\(data[indexPath.row].remainingTime)日"
            cell.periodLabelLeft.text = ""

        } else {
            cell.periodLabelLeft.text = "残り\(data[indexPath.row].remainingTime)日"
            cell.periodLabelRight.text = ""

        }
        cell.editButton.tag = data[indexPath.row].id
        cell.plusButton.tag = data[indexPath.row].id
        cell.minusButton.tag = data[indexPath.row].id
        cell.checkButton.tag = data[indexPath.row].id
        cell.delegate = self
        cell.updateDelegate = self
        let theme = r.user.object(forKey: "theme") ?? 1
        cell.periodFrame.layer.borderColor = UIColor(named: "AccentColor\(theme)")?.cgColor
        cell.progressBar.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.editButton.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.checkButton.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.minusButton.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.plusButton.tintColor = UIColor(named: "AccentColor\(theme)")
        cell.periodLabelRight.textColor = UIColor(named: "AccentColor\(theme)")
        return cell
    }
    
    func catchData(selectedCell: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextStoryboard = storyboard.instantiateViewController(withIdentifier: "EditStoryboard") as! EditViewController
        nextStoryboard.selectedCell = selectedCell
        self.show(nextStoryboard, sender: self)
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        if data.count > 19 {
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
