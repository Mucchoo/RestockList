//
//  SettingViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/27.
//

import UIKit

class SettingViewController: UITableViewController {
    
    @IBOutlet var iconBackground: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconBackground.forEach{ $0.layer.cornerRadius = 8}
    }
}
