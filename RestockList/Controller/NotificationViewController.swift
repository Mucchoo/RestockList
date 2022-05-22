//
//  NotificationViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/30.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var button: UIButton!
    let pickerArray: [Int] = ([Int])(1...30)
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 20
        picker.dataSource = self
        picker.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { isPermitted, error in
            print("許可：\(isPermitted)")
        }
        notificationCenter.delegate = self
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
    
    @IBAction func testButtonTapped(_ sender: UIButton) {
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = "title"
                content.body = "BODY"
                content.sound = UNNotificationSound.default
                var date = DateComponents()
                date.hour = 15
                date.minute = 35
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: "xxx", content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request) { error in }
                print("リクエスト\(request)")
            }
        }
    }
}
