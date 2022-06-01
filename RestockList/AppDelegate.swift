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
        //アプリ起動回数を記録
        let launchedTimes = Data.user.object(forKey: "launchedTimes") as? Int ?? 0
        Data.user.set(launchedTimes + 1, forKey: "launchedTimes")
        //内課金有効化
        Purchases.configure(withAPIKey: "appl_iJTYZXESAQcDrvNZmKCudSLubQU")
        //バックグラウンド更新有効化
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yazujumusa.RestockList.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        //通知の許可
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]){ (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
        }
        return true
    }
    //30分毎にバックグラウンド更新をセット
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.yazujumusa.RestockList.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
        }
        catch {
            print("app refreshを予約時のエラー: \(error)")
        }
    }
    //バックグラウンド更新
    func handleAppRefresh(task: BGAppRefreshTask) {
        //次のバックグラウンド処理を予約
        self.scheduleAppRefresh()
        //日付が変わっていた場合アイテムの残り日数を更新
        let realm = Data.realm
        let data = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        let currentDate = Int(floor(Date().timeIntervalSince1970)/86400)
        guard let lastDate = Data.user.object(forKey: "lastDate") as? Int else { return }
        let elapsedDays = currentDate - lastDate
        guard elapsedDays > 0 else { return }
        realm.beginWrite()
        for Item in realm.objects(Item.self) {
            Item.remainingTime -= elapsedDays
            if Item.remainingTime < 0 {
                Item.remainingTime = 0
            }
        }
        try! realm.commitWrite()
        Data.user.set(currentDate, forKey: "lastDate")
        //残り少ないアイテムを通知
        var itemNotRemaining = ""
        let notificationCondition = Data.user.object(forKey: "notificationCondition") as? Int ?? 3
        data.filter({$0.remainingTime < notificationCondition + 1}).forEach({ item in
            itemNotRemaining += "\(item.name) "
        })
        guard itemNotRemaining != "" else { return }
        let content = UNMutableNotificationContent()
        content.title = "無くなりそうなアイテムがあります"
        content.body = "\(itemNotRemaining)が残りわずかです。"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
//フォアグラウンド状態で通知
extension AppDelegate: UNUserNotificationCenterDelegate{
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.banner, .list, .sound])
   }
}

