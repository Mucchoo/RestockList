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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = 20
        picker.dataSource = self
        picker.delegate = self
        
        let notificationCondition = UserDefaults.standard.object(forKey: "notificationCondition") as? Int ?? 3
        picker.selectRow(notificationCondition - 1 , inComponent: 0, animated: true)
    }
    
    
    let pickerArray: [Int] = ([Int])(1...30)

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
        UserDefaults.standard.set(selected, forKey: "notificationCondition")
        navigationController?.popViewController(animated: true)
    }
    
}
