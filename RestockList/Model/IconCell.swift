//
//  IconCell.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/01.
//

import UIKit

class IconCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    func setImage(row: Int){
        image.image = UIImage(named: "Icon\(row)")
    }
}
