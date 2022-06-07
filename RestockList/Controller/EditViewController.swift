//
//  EditViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import RealmSwift
import UIKit

class EditViewController: UIViewController {
        
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var textFieldBackground: UIView!
    @IBOutlet weak var periodPickerView: UIPickerView!

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
        saveButton.layer.cornerRadius = 20
        deleteButton.layer.cornerRadius = 20
        saveButton.setShadow()
        deleteButton.setShadow()
        //編集中のアイテム情報を反映
        let realm = DataModel.realm
        let period = realm.object(ofType: Item.self, forPrimaryKey: selectedCell)?.period ?? 1
        periodPickerView.selectRow(period - 1 , inComponent: 0, animated: true)
        itemTextField.text = realm.object(ofType: Item.self, forPrimaryKey: selectedCell)?.name ?? ""
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        saveButton.backgroundColor = ThemeModel.color
        deleteButton.tintColor = ThemeModel.color
        deleteButton.layer.borderColor = ThemeModel.color.cgColor
        textFieldBackground.backgroundColor = ThemeModel.color
        itemTextField.tintColor = ThemeModel.color
    }
    //編集内容を保存
    @IBAction func saveAction(_ sender: UIButton) {
        guard !itemTextField.text!.isEmpty else {
            itemTextField.placeholder = "アイテム名を入力してください"
            return
        }
        RealmModel.editItem(to: selectedCell, name: itemTextField.text!, period: periodPickerView.selectedRow(inComponent: 0) + 1)
        navigationController?.popToRootViewController(animated: true)
    }
    //アイテムを削除
    @IBAction func deleteAction(_ sender: UIButton) {
        RealmModel.deleteItem(to: selectedCell)
        navigationController?.popViewController(animated: true)
    }
    
}
//決定ボタンでキーボードを閉じる
extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemTextField.endEditing(true)
        return true
    }
}
//Picker関連
extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
}
