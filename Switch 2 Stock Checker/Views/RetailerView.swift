//
//  RetailerView.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/12/25.
//

import SwiftUI

struct RetailerView: View {
    @Binding var retailer: Retailer
    @State var isAvailable: Bool
    let speakerImage = Image(systemName: "speaker.wave.3")
    let muteImage = Image(systemName: "speaker.slash")
    
    var body: some View {
        HStack {
            Text("\(retailer.name): ")
                .frame(width: 70, alignment: .leading)
            Spacer()
            AvailableView(isAvailable: $isAvailable)

            Link("Go", destination: retailer.url)
                .focusable(false)
            Spacer()
            Toggle("\(retailer.soundEnabled ? speakerImage : muteImage)", isOn: $retailer.soundEnabled)
                .frame(width: 40, alignment: .leading)
        }
        .frame(height: 15, alignment: .center)
    }
}

struct RetailerView_Previews: PreviewProvider {
    @State static var retailer = Retailer(named: "Walmart", withURL: "https://www.walmart.com")
    @State static var isAvailable = true
    static var previews: some View {
        RetailerView(retailer: $retailer, isAvailable: isAvailable)
            .frame(width: 300)
            .padding()
    }
}
