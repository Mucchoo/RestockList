//
//  SceneDelegate.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        //アプリ終了時にウィジェットを更新
        WidgetCenter.shared.reloadAllTimelines()
        //アプリ終了時にバックグラウンド処理を予約
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.scheduleAppRefresh()
        }
    }
    
}
