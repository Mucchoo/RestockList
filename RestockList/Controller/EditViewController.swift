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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldBackground: UIView!
    @IBOutlet weak var periodPickerView: UIPickerView!

    private let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeKeyboard))
    private var periodArray = ([Int])(1...365)
    var selectedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate設定
        nameTextField.delegate = self
        periodPickerView.dataSource = self
        periodPickerView.delegate = self
        //UI調整
        textFieldBackground.layer.cornerRadius = 10
        textFieldBackground.layer.opacity = 0.1
        deleteButton.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
        deleteButton.setShadow()
        saveButton.setShadow()
        //編集中のアイテム情報を反映
        periodPickerView.selectRow(RealmModel.getExpendablePeriod(from: selectedCell) - 1 , inComponent: 0, animated: true)
        nameTextField.text = RealmModel.getExpendableName(from: selectedCell)
        //背景タップ時にキーボード閉じる
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        //キーボードに完了ボタンを追加
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([spacelItem, doneItem], animated: true)
        nameTextField.inputAccessoryView = toolbar
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        textFieldBackground.backgroundColor = ThemeModel.color
        saveButton.backgroundColor = ThemeModel.color
        nameTextField.tintColor = ThemeModel.color
        deleteButton.tintColor = ThemeModel.color
        doneItem.tintColor = ThemeModel.color
    }
    //完了ボタンタップ時
    @objc func closeKeyboard() {
        nameTextField.resignFirstResponder()
    }
    //編集内容を保存
    @IBAction func saveAction(_ sender: UIButton) {
        guard !nameTextField.text!.isEmpty else {
            nameTextField.placeholder = R.string.localizable.namePlaceholder()
            return
        }
        RealmModel.editExpendable(to: selectedCell, name: nameTextField.text!, period: periodPickerView.selectedRow(inComponent: 0) + 1)
        navigationController?.popToRootViewController(animated: true)
    }
    //アイテムを削除
    @IBAction func deleteAction(_ sender: UIButton) {
        RealmModel.deleteExpendable(to: selectedCell)
        navigationController?.popViewController(animated: true)
    }
    
}
//決定ボタンでキーボードを閉じる
extension EditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.endEditing(true)
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
