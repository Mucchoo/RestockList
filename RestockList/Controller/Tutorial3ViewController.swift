//
//  Tutorial3ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class Tutorial3ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var circle: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 20
        Shadow.setTo(card)
        circle.layer.cornerRadius = 400
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        background.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
}
