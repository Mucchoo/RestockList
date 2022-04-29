//
//  TableViewItem.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import RealmSwift
class Item: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var period: Int = 1
    @objc dynamic var remainingTime = 0
    @objc dynamic var id = UUID().hashValue
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Item {
    private static var realm: Realm = try! Realm()
 
    static func all() -> Results<Item> {
        realm.objects(self)
    }
 
    static func create(with item: Item) {
        try! realm.write {
            realm.create(Item.self, value: item, update: .all)
        }
    }
}
