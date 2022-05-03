//
//  realm.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import Foundation
import RealmSwift

struct r {
    static var realm: Realm = {
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yazujumusa.RestockListWidget")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
        return realm
    }()
    
    static var user = UserDefaults(suiteName: "group.com.yazujumusa.RestockListWidget")!
}
