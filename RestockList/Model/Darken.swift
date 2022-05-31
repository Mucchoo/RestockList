//
//  Settings.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/31.
//

import UIKit
//一瞬背景を黒くする
struct Darken {
    static func view(_ view: UIView) {
        view.backgroundColor = UIColor(.black.opacity(0.3))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            view.backgroundColor = UIColor(.black.opacity(0))
        }
    }
}
