//
//  EditViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import RealmSwift
import UIKit

class EditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
        
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var periodPickerView: UIPickerView!
    @IBOutlet weak var itemTextField: UITextField!
    
    let realm = try! Realm()
    var data = [TableViewItem]()
    var periodArray:[Int] = ([Int])(1...365)
    var selectedCell: Int = 0
    let myTableViewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTextField.layer.borderWidth = 3
        itemTextField.layer.cornerRadius = 15
        itemTextField.layer.borderColor = UIColor.tintColor.cgColor
        itemTextField.becomeFirstResponder()
        deleteButton.layer.cornerRadius = 15
        deleteButton.layer.borderColor = UIColor.tintColor.cgColor
        deleteButton.layer.borderWidth = 3
        
        itemTextField.delegate = self
        periodPickerView.dataSource = self
        periodPickerView.delegate = self
        
        data = realm.objects(TableViewItem.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        periodPickerView.selectRow(realm.object(ofType: TableViewItem.self, forPrimaryKey: selectedCell)!.period - 1, inComponent: 0, animated: true)
        itemTextField.text = realm.object(ofType: TableViewItem.self, forPrimaryKey: selectedCell)!.item
        
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
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        if itemTextField.text != "" {
            let period = periodPickerView.selectedRow(inComponent: 0) + 1
            let item = itemTextField.text!
            realm.beginWrite()
            let editingItem = realm.object(ofType: TableViewItem.self, forPrimaryKey: selectedCell)!
            editingItem.period = period
            editingItem.item = item
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
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        realm.beginWrite()
        realm.delete(realm.object(ofType: TableViewItem.self, forPrimaryKey: selectedCell)!)
        try! realm.commitWrite()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}
