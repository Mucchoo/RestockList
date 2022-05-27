//
//  EditProtocol.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/26.
//

import Foundation
//アイテム編集ボタンを押した時にcellを判別する
protocol EditProtocol {
    func catchData(selectedCell: Int)
}
