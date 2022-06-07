//
//  WindowModel.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/06/07.
//

import UIKit

struct WindowModel {
    //iOS15以降でも警告が出ないwindow
    static var window: UIWindow {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return (windowScene?.windows.first)!
    }
}
