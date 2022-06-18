//
//  IconViewController.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/01.
//

import UIKit

class IconCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    //アイテムサイズ
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.itemSize = CGSize(width: (collectionView.bounds.width - 40)/3, height: (collectionView.bounds.width - 40)/3)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.cell, for: indexPath)!
        cell.setImage(row: indexPath.row)
        cell.iconImage.layer.cornerRadius = 20
        cell.layer.masksToBounds = false
        cell.layer.cornerRadius = 20
        cell.setShadow()
        return cell
    }
    //アイコンの変更
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UIApplication.shared.setAlternateIconName(nil)
        }
        UIApplication.shared.setAlternateIconName(R.string.localizable.appIcon() + String(indexPath.row))
        navigationController?.popViewController(animated: true)
    }
}
