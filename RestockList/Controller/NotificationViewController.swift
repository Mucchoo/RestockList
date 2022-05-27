//
//  NotificationViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/30.
//

import UIKit

class NotificationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var button: UIButton!
    
    let pickerArray = ([Int])(1...30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate設定
        picker.dataSource = self
        picker.delegate = self
        //UI調整
        button.layer.cornerRadius = 20
        Shadow.setTo(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //テーマカラーを反映
        let theme = Data.user.object(forKey: "theme") ?? 1
        button.backgroundColor = UIColor(named: "AccentColor\(theme)")
        //通知設定を初期値に反映
        let notificationCondition = Data.user.object(forKey: "notificationCondition") as? Int ?? 3
        picker.selectRow(notificationCondition - 1 , inComponent: 0, animated: true)
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
    //通知設定を保存
    @IBAction func notificationAction(_ sender: UIButton) {
        let selected = picker.selectedRow(inComponent: 0) + 1
        Data.user.set(selected, forKey: "notificationCondition")
        navigationController?.popViewController(animated: true)
    }
    
}
