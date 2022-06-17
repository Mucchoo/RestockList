//
//  Tutorial2ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class TutorialSecondViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet var itemImage: [UIImageView]!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI調整
        cardView.setShadow()
        cardView.layer.cornerRadius = 20
        circleView.layer.cornerRadius = 400
        itemImage.forEach { $0.setShadow() }
    }
    //テーマカラーを反映
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.backgroundColor = ThemeModel.color
        circleView.backgroundColor = ThemeModel.color
    }
}
