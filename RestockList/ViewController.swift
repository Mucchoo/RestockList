//
//  ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import RealmSwift
import UIKit

class ViewController: UITableViewController, EditProtocol, UpdateProtocol {
    
    var data = [TableViewItem]()
    let realm = try! Realm()
    var currentDate: Int?
    var lastDate: Int?
    var editUIViewController = EditUIViewController()
    var myViewController = ViewController()
    var delegate : EditProtocol?
    var updateDelegate: UpdateProtocol?
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var periodLabelLeft: UILabel!
    @IBOutlet weak var periodLabelRight: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemFrame: UIView!
    @IBOutlet weak var periodFrame: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        itemFrame.layer.cornerRadius = 15
        periodFrame.layer.borderWidth = 3
        periodFrame.layer.borderColor = UIColor.tintColor.cgColor
        progressBar.transform = CGAffineTransform(scaleX: 1, y: 11)
        data = realm.objects(TableViewItem.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        
        currentDate = Int(Date().timeIntervalSince1970)
        if let current = currentDate, let last = lastDate {
            if current > last {
                realm.beginWrite()
                for Item in realm.objects(TableViewItem.self) {
                    Item.remainingTime -= (current - last)
                }
                try! realm.commitWrite()
            }
        }
        lastDate = currentDate
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
        let nextStoryboard = storyboard.instantiateViewController(withIdentifier: "EditStoryboard") as! EditUIViewController
        nextStoryboard.selectedCell = selectedCell
        self.show(nextStoryboard, sender: self)
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        delegate?.catchData(selectedCell: sender.tag)
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        if realm.object(ofType: TableViewItem.self, forPrimaryKey: sender.tag)!.remainingTime < realm.object(ofType: TableViewItem.self, forPrimaryKey: sender.tag)!.period {
            realm.beginWrite()
            realm.object(ofType: TableViewItem.self, forPrimaryKey: sender.tag)!.remainingTime += 1
            try! realm.commitWrite()
            updateDelegate?.updateTableView()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        if realm.object(ofType: TableViewItem.self, forPrimaryKey: sender.tag)!.remainingTime > 0 {
            realm.beginWrite()
            realm.object(ofType: TableViewItem.self, forPrimaryKey: sender.tag)!.remainingTime -= 1
            try! realm.commitWrite()
            updateDelegate?.updateTableView()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        realm.beginWrite()
        realm.object(ofType: TableViewItem.self, forPrimaryKey: sender.tag)!.remainingTime = realm.object(ofType: TableViewItem.self, forPrimaryKey: sender.tag)!.period
        try! realm.commitWrite()
        updateDelegate?.updateTableView()
    }
}
