//
//  realm.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/03.
//

import Foundation
import RealmSwift

struct DataModel {
    //realmの保存先をapp groupに設定してwidgetと共有
    static var realm: Realm = {
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yazujumusa.restock-list")!
        config.fileURL = url.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
        return realm
    }()
    //userDefaultsの保存先をapp groupに設定してwidgetと共有
    static var user = UserDefaults(suiteName: "group.com.yazujumusa.restock-list")!
}
