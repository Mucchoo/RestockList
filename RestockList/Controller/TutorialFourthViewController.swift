//
//  Tutorial4ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class TutorialFourthViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI調整
        cardView.layer.cornerRadius = 20
        startButton.layer.cornerRadius = 20
        circleView.layer.cornerRadius = 400
        cardView.setShadow()
        startButton.setShadow()
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        let theme = Data.user.object(forKey: "theme") ?? 1
        listImageView.tintColor = UIColor(named: "AccentColor\(theme)")
        backgroundView.backgroundColor = UIColor(named: "AccentColor\(theme)")
        startButton.backgroundColor = UIColor(named: "AccentColor\(theme)")
        circleView.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
    //チュートリアルを閉じる
    @IBAction func startAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
