//
//  Tutorial4ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class Tutorial4ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var circle: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        card.layer.cornerRadius = 20
        startButton.layer.cornerRadius = 20
        circle.layer.cornerRadius = 400
        Shadow.setTo(card)
        Shadow.setTo(startButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        image.tintColor = UIColor(named: "AccentColor\(theme)")
        background.backgroundColor = UIColor(named: "AccentColor\(theme)")
        startButton.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
