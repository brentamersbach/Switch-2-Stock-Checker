//
//  RetailerView.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/12/25.
//

import SwiftUI

struct RetailerView: View {
    @Binding var retailer: Retailer
    var isAvailable: Bool
    let speakerImage = Image(systemName: "speaker.wave.3")
    let muteImage = Image(systemName: "speaker.slash")
    
    var body: some View {
        HStack {
            Text("\(retailer.name): ")
                .frame(width: 70, alignment: .leading)
            Spacer()
            AvailableView(isAvailable: $retailer.isAvailable)
//            if retailer.isAvailable == false {
//                UnavailableView()
//            } else {
//                AvailableView()
//            }
            Link("Go", destination: retailer.url)
                .focusable(false)
            Spacer()
            Toggle("\(retailer.soundEnabled ? speakerImage : muteImage)", isOn: $retailer.soundEnabled)
                .frame(width: 40, alignment: .leading)
        }
        .frame(height: 15, alignment: .center)
    }
}

//#Preview {
//    RetailerView()
//}
