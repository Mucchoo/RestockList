//
//  ProViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/02.
//

import UIKit

class ProViewController: UIViewController {

    @IBOutlet var iconBackground: [UIView]!
    @IBOutlet weak var button: UIButton!
    @IBOutlet var image: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconBackground.forEach{ $0.layer.cornerRadius = 15}
        button.layer.cornerRadius = 20
        image.forEach{ $0.layer.cornerRadius = 20 }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let theme = UserDefaults.standard.object(forKey: "theme") {
            iconBackground.forEach{ $0.backgroundColor = UIColor(named: "AccentColor\(theme)") }
            button.backgroundColor = UIColor(named: "AccentColor\(theme)")
        }
    }
}
