//
//  TableViewItem.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import UIKit
import RealmSwift
//realmに保存するアイテム
class Expendable: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var period: Int = 1
    @objc dynamic var id = UUID().hashValue
    @objc dynamic var expireDate: Date = Date()
    
    var remainingDateCount: Int {
        let calendar = Calendar.current
        
        let startOfDayExpireDate = calendar.startOfDay(for: self.expireDate)
        let startOfDayCurrentDate = calendar.startOfDay(for: Date())
        
        if let daysUntilExpire = calendar.dateComponents([.day], from: startOfDayCurrentDate, to: startOfDayExpireDate).day {
            return daysUntilExpire
        }
        
        return 0
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
