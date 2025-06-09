//
//  ContentView.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/8/25.
//

import SwiftUI
import AudioToolbox

struct ContentView: View {
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    let walmartURL: URL = URL(string: "https://www.walmart.com/ip/Nintendo-Switch-2-System/15949610846")!
    @State private var walmartStatus: Bool = false
    let targetURL: URL = URL(string: "https://www.target.com/p/nintendo-switch-2-console/-/A-94693225")!
    @State private var targetStatus: Bool = false
    
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
        
        if contentText.contains("Out of stock") {
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
        }
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Text("Walmart: ")
                Spacer()
                if walmartStatus == false {
                    AvailableView()
                } else {
                    UnavailableView()
                }
            }
            HStack {
                Text("Target: ")
                Spacer()
                if targetStatus == false {
                    AvailableView()
                } else {
                    UnavailableView()
                }
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
