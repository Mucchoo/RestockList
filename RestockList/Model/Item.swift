//
//  TableViewItem.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import RealmSwift
class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var period: Int = 1
    @objc dynamic var remainingTime = 0
    @objc dynamic var id = UUID().hashValue
    override static func primaryKey() -> String? {
        return "id"
    }
}
