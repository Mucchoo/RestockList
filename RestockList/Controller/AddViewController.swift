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
    //アイテム消費期間の選択肢の配列
    let pickerArray = ([Int])(1...365)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI調整
        textFieldBackground.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 20
        itemTextField.delegate = self
        periodPickerView.dataSource = self
        periodPickerView.delegate = self
        Shadow.setTo(addButton)
        //TextField自動フォーカス
        itemTextField.becomeFirstResponder()
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        let theme = Data.user.object(forKey: "theme") ?? 1
        addButton.backgroundColor = UIColor(named: "AccentColor\(theme)")
        textFieldBackground.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
    //決定ボタンでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemTextField.endEditing(true)
        return true
    }
    //Pickerの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Pickerの行の数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    //Pickerの選択項目
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerArray[row])
    }
    //アイテムをrealmデータに追加
    @IBAction func addAction(_ sender: Any) {
        if itemTextField.text != "" {
            let period = periodPickerView.selectedRow(inComponent: 0) + 1
            let item = itemTextField.text!
            let realm = Data.realm
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
