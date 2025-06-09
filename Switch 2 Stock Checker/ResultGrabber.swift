//
//  ResultGrabber.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/8/25.
//

import Foundation

class ResultGrabber {
    var content: String = ""
    
    func grabResults() async -> String {
        let walmartURL: URL = URL("https://www.walmart.com/ip/Nintendo-Switch-2-System/15949610846")!
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
        return result
    }
    
    init() async {
        self.content = ""
    }
}
