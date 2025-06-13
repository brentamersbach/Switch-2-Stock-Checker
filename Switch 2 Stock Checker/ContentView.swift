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
    
    @AppStorage("enableLogging") var enableLogging: Bool = false
    
    let speakerImage = Image(systemName: "speaker.wave.3")
    
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
            for i in retailers.indices {
               await retailers[i].grabResults(withLogging: enableLogging)
            }
        }
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            ForEach($retailers, id: \.id) { $retailer in
                HStack {
                    Text("\(retailer.name): ")
                    Spacer()
                    if retailer.isAvailable == false {
                        UnavailableView()
                    } else {
                        AvailableView()
                    }
                    Link("Go", destination: retailer.url)
                        .focusable(false)
                    Toggle("\(speakerImage)", isOn: $retailer.soundEnabled)
                }
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
