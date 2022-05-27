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
        //コレクションのアイテムサイズ
        layout.itemSize = CGSize(width: (collectionView.frame.width - 40)/3, height: (collectionView.frame.width - 40)/3)
    }
    //セクションの数
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //アイテムの数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    //アイテムの生成
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IconCell
        cell.setImage(row: indexPath.row)
        cell.layer.cornerRadius = 20
        Shadow.setTo(cell)
        return cell
    }
    //アイコンの変更
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UIApplication.shared.setAlternateIconName(nil)
        }
        UIApplication.shared.setAlternateIconName("AppIcon\(indexPath.row)")
    }
}
