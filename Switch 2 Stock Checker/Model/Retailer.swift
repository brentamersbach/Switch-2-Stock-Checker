//
//  Retailer.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/12/25.
//

import Foundation
import AudioToolbox
import SwiftUI

class Retailer: Identifiable {
    let id = UUID()
    var name: String
    var url: URL
    @AppStorage var soundEnabled: Bool
    var isAvailable: Bool
    private let unavailablePhrases: [String] = ["confirm that you’re human", "out of stock", "not available", "in store only", "exclusively in stores"]
    
    init(named name: String, withURL url: String) {
        self.name = name
        self.url = URL(string: url)!
        self.isAvailable = false
        self._soundEnabled = AppStorage(wrappedValue: true, "\(name).soundEnabled")
    }
    
    func grabResults(withLogging enableLogging: Bool) async {
        #if DEBUG
        print("URL: \(url.absoluteString)")
        #endif
        
        var content: String? = ""
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
                content = requestString
            } else {
                content = nil
            }
        } catch {
            print(error.localizedDescription)
        }
        var result = false
        if statusCode == 200 {
            if let content = content?.lowercased() {
                for phrase in unavailablePhrases {
                    if content.contains(phrase) {
                        return
                    }
                }
                #if DEBUG
                print("Hit!")
                #endif

                if enableLogging {
                    writeLog(for: content, of: url)
                }
                if self.soundEnabled {
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
                }
                result = true
            }
        }
        self.isAvailable = result
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
}
