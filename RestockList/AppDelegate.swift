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
        let launchedTimes = DataModel.user.object(forKey: "launchedTimes") as? Int ?? 0
        DataModel.user.set(launchedTimes + 1, forKey: "launchedTimes")
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
    //残り少ないアイテムを通知
    func handleAppRefresh(task: BGAppRefreshTask) {
        self.scheduleAppRefresh()
        RealmModel.reflectElapsedDays()
        guard RealmModel.getFewRemainingItems() != "" else { return }
        let content = UNMutableNotificationContent()
        content.title = "無くなりそうなアイテムがあります"
        content.body = "\(RealmModel.getFewRemainingItems())が残りわずかです。"
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

