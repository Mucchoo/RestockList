//
//  realmModel.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/06/07.
//

import UIKit
import RealmSwift

struct RealmModel {
    //日付が変わっていた場合アイテムの残り日数を更新
    static func reflectElapsedDays() {
        let realm = DataModel.realm
        let currentDate = Int(floor(Date().timeIntervalSince1970)/86400)
        guard let lastDate = DataModel.user.object(forKey: "lastDate") as? Int else { return }
        let elapsedDays = currentDate - lastDate
        guard elapsedDays > 0 else { return }
        realm.beginWrite()
        for Item in realm.objects(Item.self) {
            Item.remainingTime -= elapsedDays
            if Item.remainingTime < 0 {
                Item.remainingTime = 0
            }
        }
        try! realm.commitWrite()
        DataModel.user.set(currentDate, forKey: "lastDate")
    }
    //残り少ないアイテムを取得
    static func getFewRemainingItems() -> String {
        let realm = DataModel.realm
        let items = realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        var itemNotRemaining = ""
        let notificationCondition = DataModel.user.object(forKey: "notificationCondition") as? Int ?? 3
        items.filter({$0.remainingTime < notificationCondition + 1}).forEach({ item in
            itemNotRemaining += "\(item.name) "
        })
        return itemNotRemaining
    }
    //残り日数を1日増やす
    static func plusRemainingTime(to: Int) {
        let realm = DataModel.realm
        if realm.object(ofType: Item.self, forPrimaryKey: to)!.remainingTime < realm.object(ofType: Item.self, forPrimaryKey: to)!.period {
            realm.beginWrite()
            realm.object(ofType: Item.self, forPrimaryKey: to)!.remainingTime += 1
            try! realm.commitWrite()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    //残り日数を1日減らす
    static func minusRemainingTime(to: Int) {
        let realm = DataModel.realm
        if realm.object(ofType: Item.self, forPrimaryKey: to)!.remainingTime > 0 {
            realm.beginWrite()
            realm.object(ofType: Item.self, forPrimaryKey: to)!.remainingTime -= 1
            try! realm.commitWrite()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    //残り日数を完全に回復
    static func fillRemainingTime(to: Int) {
        let realm = DataModel.realm
        realm.beginWrite()
        realm.object(ofType: Item.self, forPrimaryKey: to)!.remainingTime = realm.object(ofType: Item.self, forPrimaryKey: to)!.period
        try! realm.commitWrite()
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    //アイテムを追加
    static func addItem(name: String, period: Int) {
        let realm = DataModel.realm
        realm.beginWrite()
        let newItem = Item()
        newItem.period = period
        newItem.remainingTime = period
        newItem.name = name
        realm.add(newItem)
        try! realm.commitWrite()
    }
    //アイテムを編集
    static func editItem(to: Int, name: String, period: Int) {
        let realm = DataModel.realm
        realm.beginWrite()
        let editingItem = realm.object(ofType: Item.self, forPrimaryKey: to)!
        editingItem.period = period
        editingItem.name = name
        if editingItem.period < editingItem.remainingTime {
            editingItem.remainingTime = editingItem.period
        }
        try! realm.commitWrite()
    }
    //アイテムを削除
    static func deleteItem(to: Int) {
        let realm = DataModel.realm
        realm.beginWrite()
        realm.delete(realm.object(ofType: Item.self, forPrimaryKey: to)!)
        try! realm.commitWrite()
    }
    //アイテムを取得
    static func getItems() -> [Item] {
        let realm = DataModel.realm
        return realm.objects(Item.self).sorted(by: { $0.remainingTime < $1.remainingTime })
    }
}
