//
//  IconViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/01.
//

import UIKit

class IconViewController: UICollectionViewController {
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.itemSize = CGSize(width: (collectionView.frame.width - 40)/3, height: (collectionView.frame.width - 40)/3)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IconCell
        cell.setImage(row: indexPath.row)
        cell.layer.cornerRadius = 20
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: CGFloat(collectionView.frame.width/3 - 40), height: CGFloat(collectionView.frame.width/3 - 40))
//    }
}
