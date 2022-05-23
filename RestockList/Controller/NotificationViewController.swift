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
    let pickerArray: [Int] = ([Int])(1...30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 20
        Shadow.setTo(button)
        picker.dataSource = self
        picker.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        button.backgroundColor = UIColor(named: "AccentColor\(theme)")
        let notificationCondition = r.user.object(forKey: "notificationCondition") as? Int ?? 3
        picker.selectRow(notificationCondition - 1 , inComponent: 0, animated: true)
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
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let selected = picker.selectedRow(inComponent: 0) + 1
        r.user.set(selected, forKey: "notificationCondition")
        navigationController?.popViewController(animated: true)
    }
    
}
