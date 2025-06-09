//
//  ContentView.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/8/25.
//

import SwiftUI
import AudioToolbox

struct ContentView: View {
    @State private var contentText: String = ""
    @State private var status: Bool = false
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    func grabResults() async {
        let walmartURL: URL = URL(string: "https://www.walmart.com/ip/Nintendo-Switch-2-System/15949610846")!
        print("URL: \(walmartURL.absoluteString)")
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
            status = false
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
        } else {
            status = true
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
        }
    }
    
    func refreshData() {
        Task {
            print("Timer fired")
            await grabResults()
        }
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack {
                Text("Walmart: ")
                if status == false {
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 10, height: 10)
                        Text("Unavailable")
                            .bold()
                    }
                } else {
                    HStack {
                        Circle()
                            .fill(Color.green)
                        Text("Available")
                            .bold()
                    }
                }
            }
        }
        .frame(width: 200, height: 200)
        .task {
            await grabResults()
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
