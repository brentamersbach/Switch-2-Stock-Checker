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
    
    @State private var retailers: [Retailer] = [
        Retailer(named: "Walmart", withURL: "https://www.walmart.com/ip/Nintendo-Switch-2-System/15949610846"),
        Retailer(named: "Target", withURL: "https://www.target.com/p/nintendo-switch-2-console/-/A-94693225"),
        Retailer(named: "Best Buy", withURL: "https://www.bestbuy.com/site/nintendo-switch-2-system-nintendo-switch-2/6614313.p?skuId=6614313"),
        Retailer(named: "GameStop", withURL: "https://www.gamestop.com/consoles-hardware/nintendo-switch/consoles/products/nintendo-switch-2/20019700.html"),
        Retailer(named: "Verizon", withURL: "https://www.verizon.com/products/nintendo-switch-2-light-blue-and-light-red/")
    ]
    
    let unavailablePhrases: [String] = ["confirm that you’re human", "out of stock", "not available", "in store only", "exclusively in stores"]
        
    let walmartURL: URL = URL(string: "https://www.walmart.com/ip/Nintendo-Switch-2-System/15949610846")!
    @State private var walmartStatus: Bool = false
    @AppStorage("walmartSound") var walmartSound: Bool = true
    
    let targetURL: URL = URL(string: "https://www.target.com/p/nintendo-switch-2-console/-/A-94693225")!
    @State private var targetStatus: Bool = false
    @AppStorage("targetSound") var targetSound: Bool = true
    
    let bestBuyURL: URL = URL(string: "https://www.bestbuy.com/site/nintendo-switch-2-system-nintendo-switch-2/6614313.p?skuId=6614313")!
    @State private var bestBuyStatus: Bool = false
    @AppStorage("bestBuySound") var bestBuySound: Bool = true
    
    let gameStopURL: URL = URL(string: "https://www.gamestop.com/consoles-hardware/nintendo-switch/consoles/products/nintendo-switch-2/20019700.html")!
    @State private var gameStopStatus: Bool = false
    @AppStorage("gameStopSound") var gameStopSound: Bool = true
    
    let verizonURL: URL = URL(string: "https://www.verizon.com/products/nintendo-switch-2-light-blue-and-light-red/")!
    @State private var verizonStatus: Bool = false
    @AppStorage("verizonSound") var verizonSound: Bool = true
    
    @AppStorage("enableLogging") var enableLogging: Bool = false
    
    let speakerImage = Image(systemName: "speaker.wave.3")
    
    func grabResults(for url: URL, withSound: Bool = true) async -> Bool {
        #if DEBUG
        print("URL: \(url.absoluteString)")
        #endif
        
        var result: String? = ""
        var statusCode: Int = 0
        
        do {
            let (requestData, requestResponse) = try await URLSession.shared.data(from: url)
            if let requestResponse = requestResponse as? HTTPURLResponse {
                statusCode = requestResponse.statusCode
                #if DEBUG
                print("Status: \(statusCode)")
                #endif
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
        if var result = result {
            result = result.lowercased()
            for phrase in unavailablePhrases {
                if result.contains(phrase) {
                    return false
                }
            }
           
            #if DEBUG
            print("Hit!")
            #endif
            
            if enableLogging {
                writeLog(for: result, of: url)
            }
            
            if withSound {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
            }
            return true
            
        } else {
            return false
        }
    }
    
    func writeLog(for contents: String, of url: URL) {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let supportPath = paths[0].appending(component: "com.mac-anu.Switch-2-Stock-Checker")
        let dateFormat = Date.ISO8601FormatStyle(dateSeparator: .omitted, dateTimeSeparator: .space, timeSeparator: .omitted, timeZone: TimeZone.current)
        let date = Date().formatted(dateFormat)
        let site = url.absoluteString.split(separator: ".")[1]
        let filename = "\(site) \(date).txt"
        let filepath = supportPath.appending(component: filename)
        print(filepath)
        
        if !FileManager.default.fileExists(atPath: supportPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: supportPath, withIntermediateDirectories: true)
            } catch {
                print("Directory creation failed: \(error.localizedDescription)")
            }
        }
        
        do {
            try contents.write(to: filepath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Write to file failed: \(error.localizedDescription)")
        }
    }
    
    func refreshData() {
        #if DEBUG
        print("Timer fired")
        #endif
        Task {
            for retailer in retailers {
//                await retailer.grabResults(withSound: retailer.soundEnabled, withLogging: enableLogging)
            }
//            walmartStatus = await grabResults(for: walmartURL, withSound: walmartSound)
//            targetStatus = await grabResults(for: targetURL, withSound: targetSound)
//            bestBuyStatus = await grabResults(for: bestBuyURL, withSound: bestBuySound)
//            gameStopStatus = await grabResults(for: gameStopURL, withSound: gameStopSound)
//            verizonStatus = await grabResults(for: verizonURL, withSound: verizonSound)
        }
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            ForEach($retailers) { $retailer in
                HStack {
                    Text("\(retailer.name): ")
                    Spacer()
                    if retailer.isAvailable.wrappedValue == false {
                        UnavailableView()
                    } else {
                        AvailableView()
                    }
                    Link("Go", destination: retailer.url.wrappedValue)
                        .focusable(false)
                    Toggle("\(speakerImage)", isOn: retailer.enableSound)
                }
            }
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
                Text("GameStop: ")
                Spacer()
                if gameStopStatus == false {
                    UnavailableView()
                } else {
                    AvailableView()
                }
                Link("Go", destination: gameStopURL)
                    .focusable(false)
                Toggle("\(speakerImage)", isOn: $gameStopSound)
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
            Toggle("Enable logging", isOn: $enableLogging)
                .padding(.top)
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
