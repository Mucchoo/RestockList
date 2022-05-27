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
        //UI調整
        card.layer.cornerRadius = 20
        circle.layer.cornerRadius = 400
        Shadow.setTo(card)
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        let theme = Data.user.object(forKey: "theme") ?? 1
        background.backgroundColor = UIColor(named: "AccentColor\(theme)")
        circle.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
}
