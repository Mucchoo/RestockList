//
//  AddViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
        
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var textFieldBackground: UIView!
    @IBOutlet weak var periodPickerView: UIPickerView!
    
    private let periodArray = ([Int])(1...365)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI調整
        textFieldBackground.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 20
        itemTextField.delegate = self
        periodPickerView.dataSource = self
        periodPickerView.delegate = self
        addButton.setShadow()
        //TextField自動フォーカス
        itemTextField.becomeFirstResponder()
        //背景タップ時にキーボード閉じる
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        //キーボードに完了ボタンを追加
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeKeyboard))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        itemTextField.inputAccessoryView = toolbar
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        addButton.backgroundColor = ThemeModel.color
        textFieldBackground.backgroundColor = ThemeModel.color
    }
    //完了ボタンタップ時
    @objc func closeKeyboard() {
        itemTextField.resignFirstResponder()
    }
    //アイテムをrealmデータに追加
    @IBAction func addAction(_ sender: Any) {
        guard !itemTextField.text!.isEmpty else {
            itemTextField.placeholder = "アイテム名を入力してください"
            return
        }
        RealmModel.addItem(name: itemTextField.text!, period: periodPickerView.selectedRow(inComponent: 0) + 1)
        navigationController?.popViewController(animated: true)
    }

}
//決定ボタンでキーボードを閉じる
extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        itemTextField.endEditing(true)
        return true
    }
}
//Picker関連
extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
