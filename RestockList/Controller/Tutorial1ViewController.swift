//
//  Tutorial1ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class Tutorial1ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet var background: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        card.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = UserDefaults.standard.object(forKey: "theme") ?? 1
        arrow.tintColor = UIColor(named: "AccentColor\(theme)")
        background.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
}
