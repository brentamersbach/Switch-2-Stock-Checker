//
//  UnavailableView.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/8/25.
//

import SwiftUI

struct UnavailableView: View {
    var body: some View {
        HStack {
            Circle()
                .fill(Color.green)
            Text("Available")
                .bold()
        }
    }
}

#Preview {
    UnavailableView()
}
