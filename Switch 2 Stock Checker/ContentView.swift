//
//  ContentView.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/8/25.
//

import SwiftUI
import AudioToolbox

struct ContentView: View {
    #if DEBUG
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    #else
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    #endif
        
    let walmartURL: URL = URL(string: "https://www.walmart.com/ip/Nintendo-Switch-2-System/15949610846")!
    @State private var walmartStatus: Bool = false
    let targetURL: URL = URL(string: "https://www.target.com/p/nintendo-switch-2-console/-/A-94693225")!
    @State private var targetStatus: Bool = false
    let bestBuyURL: URL = URL(string: "https://www.bestbuy.com/site/nintendo-switch-2-system-nintendo-switch-2/6614313.p?skuId=6614313")!
    @State private var bestBuyStatus: Bool = false
    let verizonURL: URL = URL(string: "https://www.verizon.com/products/nintendo-switch-2-light-blue-and-light-red/")!
    @State private var verizonStatus: Bool = false
    
    func grabResults(for url: URL) async -> Bool {
        print("URL: \(url.absoluteString)")
        
        var contentText: String = ""
        var result: String = ""
        
        do {
            let (requestData, _) = try await URLSession.shared.data(from: walmartURL)
            if let requestString = String(data: requestData, encoding: .utf8) {
                result = requestString
            }
        } catch {
            print(error.localizedDescription)
        }
        contentText = result
        
        if contentText.lowercased().contains("out of stock") || contentText.lowercased().contains("not available") || contentText.lowercased().contains("in store only") {
            return false
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
            return true
        }
    }
    
    func refreshData() {
        print("Timer fired")
        Task {
            walmartStatus = await grabResults(for: walmartURL)
            targetStatus = await grabResults(for: targetURL)
            bestBuyStatus = await grabResults(for: bestBuyURL)
            verizonStatus = await grabResults(for: verizonURL)
        }
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Text("Walmart: ")
                Spacer()
                if walmartStatus == false {
                    UnavailableView()
                } else {
                    AvailableView()
                }
                Link("Go", destination: walmartURL)
                    .focusable(false)
            }
            HStack {
                Text("Target: ")
                Spacer()
                if targetStatus == false {
                    UnavailableView()
                } else {
                    AvailableView()
                }
                Link("Go", destination: targetURL)
                    .focusable(false)
            }
            HStack {
                Text("Best Buy: ")
                Spacer()
                if bestBuyStatus == false {
                    UnavailableView()
                } else {
                    AvailableView()
                }
                Link("Go", destination: bestBuyURL)
                    .focusable(false)
            }
            HStack {
                Text("Verizon: ")
                Spacer()
                if verizonStatus == false {
                    UnavailableView()
                } else {
                    AvailableView()
                }
                Link("Go", destination: verizonURL)
                    .focusable(false)
            }
            
        }
        .frame(width: 200, height: 200)
        .task {
            refreshData()
        }
        .onReceive(timer) { _ in
            refreshData()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
