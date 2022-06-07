//
//  Loading.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/06/07.
//

import Foundation
import UIKit

struct LoadModel {
    //ロード画面を表示
    static func showLoading(to: UIView) {
        WindowModel.window.addSubview(to)
        to.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.center = to.center
        activityIndicator.color = UIColor.white
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        to.addSubview(activityIndicator)
    }
}
