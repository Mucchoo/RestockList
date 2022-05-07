//
//  Pro.swift
//  RestockList
//
//  Created by Musa Yazuju on 2022/05/07.
//

import Foundation
import RevenueCat

struct Pro {
    static var isPro: Bool = {
        var isp = false
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if customerInfo?.entitlements["Pro"]?.isActive == true {
                isp = true
            }
        }
        return isp
    }()
}
