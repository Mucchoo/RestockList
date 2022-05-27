//
//  TableViewCell.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import RealmSwift

class TableViewCell: UITableViewCell {

    @IBOutlet weak var periodLabelLeft: UILabel!
    @IBOutlet weak var periodLabelRight: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemFrame: UIView!
    @IBOutlet weak var periodFrame: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var delegate : EditProtocol?
    var updateDelegate: UpdateProtocol?
    let realm = Data.realm
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //UI調整
        itemFrame.layer.cornerRadius = 15
        periodFrame.layer.borderWidth = 3
        periodFrame.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        progressBar.transform = CGAffineTransform(scaleX: 1, y: 10)
        Shadow.setTo(itemFrame)
    }
    //アイテムの編集
    @IBAction func editAction(_ sender: UIButton) {
        delegate?.catchData(selectedCell: sender.tag)
    }
    //残り期間を1日増やす
    @IBAction func plusAction(_ sender: UIButton) {
        if realm.object(ofType: Item.self, forPrimaryKey: sender.tag)!.remainingTime < realm.object(ofType: Item.self, forPrimaryKey: sender.tag)!.period {
            realm.beginWrite()
            realm.object(ofType: Item.self, forPrimaryKey: sender.tag)!.remainingTime += 1
            try! realm.commitWrite()
            updateDelegate?.updateTableView()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    //残り期間を1日減らす
    @IBAction func minusAction(_ sender: UIButton) {
        if realm.object(ofType: Item.self, forPrimaryKey: sender.tag)!.remainingTime > 0 {
            realm.beginWrite()
            realm.object(ofType: Item.self, forPrimaryKey: sender.tag)!.remainingTime -= 1
            try! realm.commitWrite()
            updateDelegate?.updateTableView()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    //残り期間を完全に回復する
    @IBAction func checkAction(_ sender: UIButton) {
        realm.beginWrite()
        realm.object(ofType: Item.self, forPrimaryKey: sender.tag)!.remainingTime = realm.object(ofType: Item.self, forPrimaryKey: sender.tag)!.period
        try! realm.commitWrite()
        updateDelegate?.updateTableView()
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
}
