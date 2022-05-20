//
//  AppDelegate.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import WidgetKit
import RevenueCat
import RealmSwift
import BackgroundTasks
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let launchedTimes = UserDefaults.standard.object(forKey: "LaunchedTimes") as? Int ?? 0
        UserDefaults.standard.set(launchedTimes + 1, forKey: "LaunchedTimes")
        Purchases.configure(withAPIKey: "appl_iJTYZXESAQcDrvNZmKCudSLubQU")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yazujumusa.RestockList.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound]){ (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
        }
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yazujumusa.RestockList.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
        }
        catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        self.scheduleAppRefresh()
        let realm = r.realm
        let data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        let currentDate = Int(floor(Date().timeIntervalSince1970)/86400)
        if let lastDate = UserDefaults.standard.object(forKey: "lastDate") as? Int {
            let elapsedDays = currentDate - lastDate
            if elapsedDays > 0 {
                realm.beginWrite()
                for Item in realm.objects(Item.self) {
                    Item.remainingTime -= elapsedDays
                    if Item.remainingTime < 0 {
                        Item.remainingTime = 0
                    }
                }
                try! realm.commitWrite()
                WidgetCenter.shared.reloadAllTimelines()
                var itemNotRemaining = ""
                let notificationCondition = UserDefaults.standard.object(forKey: "notificationCondition") as? Int ?? 3
                data.filter({$0.remainingTime < notificationCondition + 1}).forEach({ item in
                    itemNotRemaining += "\(item.name) "
                })
                if itemNotRemaining != "" {
                    let content = UNMutableNotificationContent()
                    content.title = "無くなりそうなアイテムがあります"
                    content.body = "\(itemNotRemaining)が残りわずかです。"
                    content.sound = UNNotificationSound.default
                    let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
        UserDefaults.standard.set(currentDate, forKey: "lastDate")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.banner, .list, .sound])
   }
}

