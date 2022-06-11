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
        for expendable in realm.objects(Expendable.self) {
            expendable.remainingTime -= elapsedDays
            if expendable.remainingTime < 0 {
                expendable.remainingTime = 0
            }
        }
        try! realm.commitWrite()
        DataModel.user.set(currentDate, forKey: "lastDate")
    }
    //残り少ないアイテムを取得
    static func getFewRemainingExpendables() -> String {
        let realm = DataModel.realm
        let expendables = realm.objects(Expendable.self).sorted(by: { $0.remainingTime < $1.remainingTime })
        var expendableNotRemaining = ""
        let notificationCondition = DataModel.user.object(forKey: "notificationCondition") as? Int ?? 3
        expendables.filter({$0.remainingTime < notificationCondition + 1}).forEach({ expendable in
            expendableNotRemaining += "\(expendable.name) "
        })
        return expendableNotRemaining
    }
    //残り日数を1日増やす
    static func plusRemainingTime(to: Int) {
        let realm = DataModel.realm
        if realm.object(ofType: Expendable.self, forPrimaryKey: to)!.remainingTime < realm.object(ofType: Expendable.self, forPrimaryKey: to)!.period {
            realm.beginWrite()
            realm.object(ofType: Expendable.self, forPrimaryKey: to)!.remainingTime += 1
            try! realm.commitWrite()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    //残り日数を1日減らす
    static func minusRemainingTime(to: Int) {
        let realm = DataModel.realm
        if realm.object(ofType: Expendable.self, forPrimaryKey: to)!.remainingTime > 0 {
            realm.beginWrite()
            realm.object(ofType: Expendable.self, forPrimaryKey: to)!.remainingTime -= 1
            try! realm.commitWrite()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    //残り日数を完全に回復
    static func fillRemainingTime(to: Int) {
        let realm = DataModel.realm
        realm.beginWrite()
        realm.object(ofType: Expendable.self, forPrimaryKey: to)!.remainingTime = realm.object(ofType: Expendable.self, forPrimaryKey: to)!.period
        try! realm.commitWrite()
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    //アイテムを追加
    static func addExpendable(name: String, period: Int) {
        let realm = DataModel.realm
        realm.beginWrite()
        let newExpendable = Expendable()
        newExpendable.period = period
        newExpendable.remainingTime = period
        newExpendable.name = name
        realm.add(newExpendable)
        try! realm.commitWrite()
    }
    //アイテムを編集
    static func editExpendable(to: Int, name: String, period: Int) {
        let realm = DataModel.realm
        realm.beginWrite()
        let editingExpendable = realm.object(ofType: Expendable.self, forPrimaryKey: to)!
        editingExpendable.period = period
        editingExpendable.name = name
        if editingExpendable.period < editingExpendable.remainingTime {
            editingExpendable.remainingTime = editingExpendable.period
        }
        try! realm.commitWrite()
    }
    //アイテムを削除
    static func deleteExpendable(to: Int) {
        let realm = DataModel.realm
        realm.beginWrite()
        realm.delete(realm.object(ofType: Expendable.self, forPrimaryKey: to)!)
        try! realm.commitWrite()
    }
    //アイテムを取得
    static var expendables: [Expendable] {
        let realm = DataModel.realm
        return realm.objects(Expendable.self).sorted(by: { $0.remainingTime < $1.remainingTime })
    }
    //アイテムの期間取得
    static func getExpendablePeriod(from: Int) -> Int {
        let realm = DataModel.realm
        return realm.object(ofType: Expendable.self, forPrimaryKey: from)?.period ?? 1
    }
    //アイテム名取得
    static func getExpendableName(from: Int) -> String {
        let realm = DataModel.realm
        return realm.object(ofType: Expendable.self, forPrimaryKey: from)?.name ?? ""
    }
}
