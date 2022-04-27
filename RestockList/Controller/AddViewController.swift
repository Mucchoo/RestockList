//
//  AddViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import RealmSwift
import UIKit

class AddViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
        
    @IBOutlet weak var periodPickerView: UIPickerView!
    @IBOutlet weak var itemTextField: UITextField!
    
    let realm = try! Realm()
    var data = [TableViewItem]()
    let myTableViewController = TableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTextField.layer.borderWidth = 3
        itemTextField.layer.cornerRadius = 15
        itemTextField.layer.borderColor = UIColor.tintColor.cgColor
        itemTextField.becomeFirstResponder()
        
        itemTextField.delegate = self
        periodPickerView.dataSource = self
        periodPickerView.delegate = self
        
    }
    
    var pickerArray:[Int] = ([Int])(1...365)
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemTextField.endEditing(true)
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerArray[row])
    }
    
    @IBAction func AddButtonTapped(_ sender: Any) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        if itemTextField.text != "" {
            let period = periodPickerView.selectedRow(inComponent: 0) + 1
            let item = itemTextField.text!
            
            realm.beginWrite()
            let newItem = TableViewItem()
            newItem.period = period
            newItem.remainingTime = period
            newItem.item = item
            realm.add(newItem)
            try! realm.commitWrite()
            
            navigationController?.popToRootViewController(animated: true)
        } else {
            itemTextField.placeholder = "アイテム名を入力してください"
        }
    }

}
