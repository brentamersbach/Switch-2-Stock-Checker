//
//  UnavailableView.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/8/25.
//

import SwiftUI

struct AvailableView: View {
    @Binding var isAvailable: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(isAvailable ? Color.green : Color.red)
                .frame(width: 10, height: 10)
            Text(isAvailable ? "Available" : "Unavailable")
                .bold()
        }
    }
}

struct AvailableView_Previews: PreviewProvider {
    @State static var isAvailable = true
    static var previews: some View {
        AvailableView(isAvailable: $isAvailable)
    }
    
}
