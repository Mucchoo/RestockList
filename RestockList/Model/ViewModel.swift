//
//  File.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/04/29.
//

import Combine
 
class ContentViewModel :ObservableObject {
    @Published var text = Item.all().first?.name ?? ""
    var saveButtonTapped = PassthroughSubject<Void, Never>()
 
    private var cancellables = [AnyCancellable]()
 
}
