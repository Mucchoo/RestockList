//
//  ThemeViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/01.
//

import UIKit

class ThemeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //テーマカラーを更新
    @IBAction func themeAction(_ sender: UIButton) {
        DataModel.user.set(sender.tag, forKey: "theme")
        navigationController?.popToRootViewController(animated: true)
    }
}
