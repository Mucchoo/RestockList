//
//  Tutorial4ViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import UIKit

class Tutorial4ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 20
        button.layer.cornerRadius = 20
        Shadow.setTo(card)
        Shadow.setTo(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = r.user.object(forKey: "theme") ?? 1
        image.tintColor = UIColor(named: "AccentColor\(theme)")
        button.backgroundColor = UIColor(named: "AccentColor\(theme)")
        background.backgroundColor = UIColor(named: "AccentColor\(theme)")
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
