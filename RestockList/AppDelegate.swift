//
//  AppDelegate.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import StoreKit
import WidgetKit
import RealmSwift
import BackgroundTasks
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //アプリ起動回数を記録
        let launchedTimes = DataModel.user.object(forKey: R.string.localizable.launchedTimes()) as? Int ?? 0
        DataModel.user.set(launchedTimes + 1, forKey: R.string.localizable.launchedTimes())
        //バックグラウンド更新有効化
        BGTaskScheduler.shared.register(forTaskWithIdentifier: R.string.localizable.refresh(), using: nil) { task in
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
        let request = BGAppRefreshTaskRequest(identifier: R.string.localizable.refresh())
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
        guard RealmModel.getFewRemainingExpendables() != "" else { return }
        let content = UNMutableNotificationContent()
        content.title = R.string.localizable.itemWillBeLost()
        content.body = RealmModel.getFewRemainingExpendables() + R.string.localizable.isFewLeft()
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: R.string.localizable.immediately(), content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
}
//フォアグラウンド状態で通知
extension AppDelegate: UNUserNotificationCenterDelegate{
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.banner, .list, .sound])
   }
}

