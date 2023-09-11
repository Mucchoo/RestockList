//
//  realmModel.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/06/07.
//

import UIKit
import RealmSwift

struct RealmModel {
    //残り少ないアイテムを取得
    static func getFewRemainingExpendables() -> String {
        let realm = DataModel.realm
        let expendables = realm.objects(Expendable.self).sorted(by: { $0.remainingDateCount < $1.remainingDateCount })
        var expendableNotRemaining = ""
        let notificationCondition = DataModel.user.object(forKey: "notificationCondition") as? Int ?? 3
        expendables.filter({$0.remainingDateCount < notificationCondition + 1}).forEach({ expendable in
            expendableNotRemaining += "\(expendable.name) "
        })
        return expendableNotRemaining
    }
    //残り日数を1日増やす・減らす
    static func updateRemainingDateCount(to id: Int, by days: Int) {
        let realm = DataModel.realm
        if let expendable = realm.object(ofType: Expendable.self, forPrimaryKey: id) {
            do {
                try realm.write {
                    let calendar = Calendar.current
                    if let newExpireDate = calendar.date(byAdding: .day, value: days, to: expendable.expireDate) {
                        expendable.expireDate = newExpireDate
                    }
                }
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            } catch {
                print("Failed updateRemainingDateCount: \(error)")
            }
        }
    }
    //残り日数を1日増やす
    static func plusRemainingDateCount(to id: Int) {
        updateRemainingDateCount(to: id, by: 1)
    }
    //残り日数を1日減らす
    static func minusRemainingDateCount(to id: Int) {
        updateRemainingDateCount(to: id, by: -1)
    }
    //残り日数を完全に回復
    static func fillremainingDateCount(to: Int) {
        let realm = DataModel.realm
        guard let expendable = realm.object(ofType: Expendable.self, forPrimaryKey: to) else { return }
        
        realm.beginWrite()
        if let newExpireDate = Calendar.current.date(byAdding: .day, value: expendable.period, to: Date()) {
            expendable.expireDate = newExpireDate
        }
        
        do {
            try realm.commitWrite()
        } catch {
            print("Failed fillremainingDateCount: \(error)")
        }
        
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    //アイテムを追加
    static func addExpendable(name: String, period: Int) {
        let realm = DataModel.realm
        realm.beginWrite()
        
        let newExpendable = Expendable()
        newExpendable.period = period
        
        if let newExpireDate = Calendar.current.date(byAdding: .day, value: period, to: Date()) {
            newExpendable.expireDate = newExpireDate
        }
        
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
        
        if editingExpendable.period < editingExpendable.remainingDateCount,
           let newExpireDate = Calendar.current.date(byAdding: .day, value: period, to: Date()) {
            editingExpendable.expireDate = newExpireDate
        }
        
        do {
            try realm.commitWrite()
        } catch {
            print("Failed editExpendable: \(error)")
        }
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
        return realm.objects(Expendable.self).sorted(by: { $0.remainingDateCount < $1.remainingDateCount })
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
