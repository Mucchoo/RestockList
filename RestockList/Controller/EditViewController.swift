//
//  EditViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import RealmSwift
import UIKit

class EditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
        
    @IBOutlet weak var textFieldBackground: UIView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var periodPickerView: UIPickerView!
    @IBOutlet weak var itemTextField: UITextField!
    
    var data = [Item]()
    var periodArray:[Int] = ([Int])(1...365)
    var selectedCell: Int = 0
    let myTableViewController = TableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        completeButton.layer.cornerRadius = 20
        deleteButton.layer.cornerRadius = 20
        deleteButton.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        deleteButton.layer.borderWidth = 3
        textFieldBackground.layer.cornerRadius = 10
        
        itemTextField.delegate = self
        periodPickerView.dataSource = self
        periodPickerView.delegate = self
        
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yazujumusa.RestockListWidget")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
        data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        let period = realm.object(ofType: Item.self, forPrimaryKey: selectedCell)?.period ?? 1
        periodPickerView.selectRow(period - 1 , inComponent: 0, animated: true)
        itemTextField.text = realm.object(ofType: Item.self, forPrimaryKey: selectedCell)?.name ?? ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let theme = UserDefaults.standard.object(forKey: "theme") {
            completeButton.backgroundColor = UIColor(named: "AccentColor\(theme)")
            deleteButton.tintColor = UIColor(named: "AccentColor\(theme)")
            deleteButton.layer.borderColor = UIColor(named: "AccentColor\(theme)")?.cgColor
            textFieldBackground.backgroundColor = UIColor(named: "AccentColor\(theme)")
        }
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemTextField.endEditing(true)
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return periodArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(periodArray[row])
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        if itemTextField.text != "" {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yazujumusa.RestockListWidget")!
            config.fileURL = url.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            
            let period = periodPickerView.selectedRow(inComponent: 0) + 1
            let item = itemTextField.text!
            realm.beginWrite()
            let editingItem = realm.object(ofType: Item.self, forPrimaryKey: selectedCell)!
            editingItem.period = period
            editingItem.name = item
            if editingItem.period < editingItem.remainingTime {
                editingItem.remainingTime = editingItem.period
            }
            try! realm.commitWrite()
            navigationController?.popToRootViewController(animated: true)
        } else {
            itemTextField.placeholder = "アイテム名を入力してください"
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yazujumusa.RestockListWidget")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
        
        realm.beginWrite()
        realm.delete(realm.object(ofType: Item.self, forPrimaryKey: selectedCell)!)
        try! realm.commitWrite()
        
        navigationController?.popViewController(animated: true)
    }
    
}
