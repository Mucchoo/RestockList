//
//  Tutorial1ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class TutorialFirstViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI調整
        cardView.layer.cornerRadius = 20
        circleView.layer.cornerRadius = 400
        cardView.setShadow()
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        let theme = Data.user.object(forKey: "theme") ?? 1
        backgroundView.backgroundColor = UIColor(named: "AccentColor\(theme)")
        circleView.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
}
