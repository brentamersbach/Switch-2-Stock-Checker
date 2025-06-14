//
//  Retailer.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/12/25.
//

import Foundation
import AudioToolbox
import SwiftUI

struct Retailer: Identifiable {
    let id = UUID()
    var name: String
    var url: URL
    @AppStorage var soundEnabled: Bool
    var isAvailable: Bool
    var unavailablePhrases: [String] = ["out of stock", "not available", "in store only", "exclusively in stores"]
    var confirmationPhrases: [String] = []
    
    init(named name: String, withURL url: String, addPhrases newPhrases: [String] = [], withConfirmation newConfirmPhrases: [String] = []) {
        self.name = name
        self.url = URL(string: url)!
        self.isAvailable = false
        self._soundEnabled = AppStorage(wrappedValue: true, "\(name).soundEnabled")
        unavailablePhrases.append(contentsOf: newPhrases)
        confirmationPhrases.append(contentsOf: newConfirmPhrases)
    }
}
