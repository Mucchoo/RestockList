//
//  Date.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/27.
//

import UIKit
import RealmSwift

class LastDate: Object {
    @objc dynamic var date: Int = 0
    override static func primaryKey() -> String {
        return "date"
    }
}
