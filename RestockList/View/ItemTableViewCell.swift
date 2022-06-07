//
//  TableViewCell.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import RealmSwift

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemFrame: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var periodFrame: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var periodLabelLeft: UILabel!
    @IBOutlet weak var periodLabelRight: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private let realm = DataModel.realm
    var editDelegate: EditProtocol?
    var updateDelegate: UpdateProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //UI調整
        itemFrame.layer.cornerRadius = 15
        itemFrame.setShadow()
        periodFrame.layer.borderWidth = 3
        periodFrame.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        progressBar.transform = CGAffineTransform(scaleX: 1, y: 10)
    }
    //アイテムの編集
    @IBAction func editAction(_ sender: UIButton) {
        editDelegate?.catchData(selectedCell: sender.tag)
    }
    //残り期間を1日増やす
    @IBAction func plusAction(_ sender: UIButton) {
        RealmModel.plusRemainingTime(to: sender.tag)
        updateDelegate?.updateTableView()
    }
    //残り期間を1日減らす
    @IBAction func minusAction(_ sender: UIButton) {
        RealmModel.minusRemainingTime(to: sender.tag)
        updateDelegate?.updateTableView()
    }
    //残り期間を完全に回復する
    @IBAction func checkAction(_ sender: UIButton) {
        RealmModel.fillRemainingTime(to: sender.tag)
        updateDelegate?.updateTableView()
    }
}
