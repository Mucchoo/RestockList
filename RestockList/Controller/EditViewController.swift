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
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var textFieldBackground: UIView!
    @IBOutlet weak var periodPickerView: UIPickerView!

    private let myTableViewController = TableViewController()
    private var periodArray = ([Int])(1...365)
    var selectedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate設定
        itemTextField.delegate = self
        periodPickerView.dataSource = self
        periodPickerView.delegate = self
        //UI調整
        textFieldBackground.layer.cornerRadius = 10
        completeButton.layer.cornerRadius = 20
        deleteButton.layer.cornerRadius = 20
        Shadow.setTo(completeButton)
        Shadow.setTo(deleteButton)
        //編集中のアイテム情報を反映
        let realm = Data.realm
        let period = realm.object(ofType: Item.self, forPrimaryKey: selectedCell)?.period ?? 1
        periodPickerView.selectRow(period - 1 , inComponent: 0, animated: true)
        itemTextField.text = realm.object(ofType: Item.self, forPrimaryKey: selectedCell)?.name ?? ""
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        let theme = Data.user.object(forKey: "theme") ?? 1
        completeButton.backgroundColor = UIColor(named: "AccentColor\(theme)")
        deleteButton.tintColor = UIColor(named: "AccentColor\(theme)")
        deleteButton.layer.borderColor = UIColor(named: "AccentColor\(theme)")?.cgColor
        textFieldBackground.backgroundColor = UIColor(named: "AccentColor\(theme)")
        itemTextField.tintColor = UIColor(named: "AccentColor\(theme)")
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
        return periodArray.count
    }
    //Pickerの選択項目
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(periodArray[row])
    }
    //編集内容を保存
    @IBAction func completeAction(_ sender: UIButton) {
        //アイテム名が空白の時はreturn
        guard !itemTextField.text!.isEmpty else {
            itemTextField.placeholder = "アイテム名を入力してください"
            return
        }
        //編集内容を保存
        let realm = Data.realm
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
    }
    //アイテムを削除
    @IBAction func deleteAction(_ sender: UIButton) {
        let realm = Data.realm
        realm.beginWrite()
        realm.delete(realm.object(ofType: Item.self, forPrimaryKey: selectedCell)!)
        try! realm.commitWrite()
        navigationController?.popViewController(animated: true)
    }
    
}
