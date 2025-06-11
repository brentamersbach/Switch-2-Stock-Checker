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
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    #else
    let timer = Timer.publish(every: 300, on: .main, in: .common).autoconnect()
    #endif
        
    let walmartURL: URL = URL(string: "https://www.walmart.com/ip/Nintendo-Switch-2-System/15949610846")!
    @State private var walmartStatus: Bool = false
    @AppStorage("walmartSound") var walmartSound: Bool = true
    
    let targetURL: URL = URL(string: "https://www.target.com/p/nintendo-switch-2-console/-/A-94693225")!
    @State private var targetStatus: Bool = false
    @AppStorage("targetSound") var targetSound: Bool = true
    
    let bestBuyURL: URL = URL(string: "https://www.bestbuy.com/site/nintendo-switch-2-system-nintendo-switch-2/6614313.p?skuId=6614313")!
    @State private var bestBuyStatus: Bool = false
    @AppStorage("bestBuySound") var bestBuySound: Bool = true
    
    let verizonURL: URL = URL(string: "https://www.verizon.com/products/nintendo-switch-2-light-blue-and-light-red/")!
    @State private var verizonStatus: Bool = false
    @AppStorage("verizonSound") var verizonSound: Bool = true
    
    @AppStorage("enableSound") var enableSound: Bool = true
    
    let speakerImage = Image(systemName: "speaker.wave.3")
    
    func grabResults(for url: URL, withSound: Bool = true) async -> Bool {
        print("URL: \(url.absoluteString)")
        
        var result: String? = ""
        var statusCode: Int = 0
        
        do {
            let (requestData, requestResponse) = try await URLSession.shared.data(from: url)
            if let requestResponse = requestResponse as? HTTPURLResponse {
                statusCode = requestResponse.statusCode
                print("Status: \(statusCode)")
            }
            if let requestString = String(data: requestData, encoding: .utf8) {
                result = requestString
            } else {
                result = nil
            }
        } catch {
            print(error.localizedDescription)
        }
        
        if statusCode != 200 {
            return false
        }
        if let result = result {
            if result.lowercased().contains("out of stock") || result.lowercased().contains("not available") || result.lowercased().contains("in store only") {
                return false
            } else {
                #if DEBUG
                print(result)
                #endif
                
                if withSound {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
                }
                return true
            }
        } else {
            return false
        }
    }
    
    func refreshData() {
        print("Timer fired")
        Task {
            walmartStatus = await grabResults(for: walmartURL, withSound: walmartSound)
            targetStatus = await grabResults(for: targetURL, withSound: targetSound)
            bestBuyStatus = await grabResults(for: bestBuyURL, withSound: bestBuySound)
            verizonStatus = await grabResults(for: verizonURL, withSound: verizonSound)
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
                Toggle("\(speakerImage)", isOn: $walmartSound)
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
                Toggle("\(speakerImage)", isOn: $targetSound)
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
                Toggle("\(speakerImage)", isOn: $bestBuySound)
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
                Toggle("\(speakerImage)", isOn: $verizonSound)
            }
        }
        .frame(width: 250)
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
