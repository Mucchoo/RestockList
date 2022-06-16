//
//  UIButtonExtension.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/06/15.
//

import UIKit

extension UIButton {
    //一瞬透明にする
    func transparentForAMoment() {
        layer.opacity = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.layer.opacity = 1
        }
    }
}
