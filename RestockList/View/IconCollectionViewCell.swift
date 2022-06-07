//
//  IconCell.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/01.
//

import UIKit
//IconViewControllerのカスタムセル
class IconCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    func setImage(row: Int){
        iconImage.image = UIImage(named: "Icon\(row)")
    }
}
