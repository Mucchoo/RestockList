//
//  Shadow.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/23.
//

import UIKit

struct Shadow {
    static func setTo(_ view: UIView) {
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
    }
}
