//
//  themeModel.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/06/07.
//

import UIKit
//テーマカラー取得
struct ThemeModel {
    static var color: UIColor {
        let theme = DataModel.user.object(forKey: "theme") ?? 1
        return UIColor(named: "AccentColor\(theme)")!
    }
}
