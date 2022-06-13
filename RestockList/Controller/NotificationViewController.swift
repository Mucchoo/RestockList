//
//  NotificationViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/30.
//

import UIKit

class NotificationViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var periodPicker: UIPickerView!
    
    private let pickerArray = ([Int])(1...30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate設定
        periodPicker.dataSource = self
        periodPicker.delegate = self
        //UI調整
        saveButton.layer.cornerRadius = 20
        saveButton.setShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //テーマカラーを反映
        saveButton.backgroundColor = ThemeModel.color
        //通知設定を初期値に反映
        let notificationCondition = DataModel.user.object(forKey: R.string.localizable.notificationCondition()) as? Int ?? 3
        periodPicker.selectRow(notificationCondition - 1 , inComponent: 0, animated: true)
    }
    //通知設定を保存
    @IBAction func notificationAction(_ sender: UIButton) {
        let selected = periodPicker.selectedRow(inComponent: 0) + 1
        DataModel.user.set(selected, forKey: R.string.localizable.notificationCondition())
        navigationController?.popViewController(animated: true)
    }
    
}

extension NotificationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
}
