//
//  ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import RealmSwift
import UIKit

class TableViewController: UITableViewController, EditProtocol, UpdateProtocol {
    
    var data = [TableViewItem]()
    let realm = try! Realm()
    let calender = Calendar(identifier: .gregorian)
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        let elapsedDays = calender.dateComponents([.day], from: UserDefaults.standard.object(forKey: "lastDate") as? Date ?? Date(), to: Date()).day!
        if elapsedDays > 0 {
            realm.beginWrite()
            for Item in realm.objects(TableViewItem.self) {
                Item.remainingTime -= elapsedDays
            }
            try! realm.commitWrite()
        }
        UserDefaults.standard.set(Date(), forKey: "lastDate")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = realm.objects(TableViewItem.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell") as! TableViewCell
        cell.itemLabel.text = data[indexPath.row].item
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
}
