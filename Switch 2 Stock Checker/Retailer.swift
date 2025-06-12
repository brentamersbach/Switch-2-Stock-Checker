//
//  Retailer.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/12/25.
//

import Foundation

class Retailer: Identifiable {
    let id = UUID()
    var name: String
    var url: URL
    @Published var soundEnabled: Bool = false
    
    init(named name: String, withURL url: String) {
        self.name = name
        self.url = URL(string: url)!
    }
}
