//
//  UnavailableView.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/8/25.
//

import SwiftUI

struct AvailableView: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.green)
                .frame(width: 10, height: 10)
            Text("Available")
                .bold()
        }
    }
}

#Preview {
    AvailableView()
}
