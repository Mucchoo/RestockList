//
//  AddViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
        
    @IBOutlet weak var periodPickerView: UIPickerView!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textFieldBackground: UIView!
    
    var data = [Item]()
    let myTableViewController = TableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldBackground.layer.cornerRadius = 10
        itemTextField.becomeFirstResponder()
        addButton.layer.cornerRadius = 20
        Shadow.setTo(addButton)
        itemTextField.delegate = self
        periodPickerView.dataSource = self
        periodPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        addButton.backgroundColor = UIColor(named: "AccentColor\(theme)")
        textFieldBackground.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
    
    let pickerArray:[Int] = ([Int])(1...365)
    
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
        if itemTextField.text != "" {
            let period = periodPickerView.selectedRow(inComponent: 0) + 1
            let item = itemTextField.text!
            let realm = r.realm
            realm.beginWrite()
            let newItem = Item()
            newItem.period = period
            newItem.remainingTime = period
            newItem.name = item
            realm.add(newItem)
            try! realm.commitWrite()
            navigationController?.popViewController(animated: true)
        } else {
            itemTextField.placeholder = "アイテム名を入力してください"
        }
    }

}
