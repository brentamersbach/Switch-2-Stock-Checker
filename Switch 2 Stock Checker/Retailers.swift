//
//  RetailerList.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/12/25.
//

import SwiftUI

class Retailers: ObservableObject {
    @Published var list: [Retailer]
    
    init() {
        self.list = []
        let walmart = Retailer(named: "Walmart", withURL: "https://www.walmart.com/ip/Nintendo-Switch-2-System/15949610846")
        self.list.append(walmart)
        let target = Retailer(named: "Target", withURL: "https://www.target.com/p/nintendo-switch-2-console/-/A-94693225")
        self.list.append(target)
        let bestbuy = Retailer(named: "Best Buy", withURL: "https://www.bestbuy.com/site/nintendo-switch-2-system-nintendo-switch-2/6614313.p?skuId=6614313")
        self.list.append(bestbuy)
        let gamestop = Retailer(named: "GameStop", withURL: "https://www.gamestop.com/consoles-hardware/nintendo-switch/consoles/products/nintendo-switch-2/20019700.html")
        self.list.append(gamestop)
        let verizon = Retailer(named: "Verizon", withURL: "https://www.verizon.com/products/nintendo-switch-2-light-blue-and-light-red/")
        self.list.append(verizon)
    }
}
