//
//  Tutorial3ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class Tutorial3ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        arrow.tintColor = UIColor(named: "AccentColor\(theme)")
        background.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
}
