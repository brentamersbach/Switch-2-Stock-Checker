//
//  Grabber.swift
//  Switch 2 Stock Checker
//
//  Created by Brent Amersbach on 6/13/25.
//
import Foundation
import AudioToolbox

class Grabber {
    
    init () {
        
    }
    
    func grabResults(for retailer: Retailer, withLogging enableLogging: Bool) async -> Bool {
        var content: String? = ""
        var statusCode: Int = 0
        var result = true
        let url: URL = retailer.url
        let unavailablePhrases: [String] = retailer.unavailablePhrases
        let confirmationPhrases: [String] = retailer.confirmationPhrases
        
        print("\nURL: \(url.absoluteString)")
        
        do {
            let (requestData, requestResponse) = try await URLSession.shared.data(from: url)
            if let requestResponse = requestResponse as? HTTPURLResponse {
                statusCode = requestResponse.statusCode

                print("Status: \(statusCode)")
            }
            if let requestString = String(data: requestData, encoding: .utf8) {
                content = requestString
            } else {
                content = nil
            }
        } catch {
            print(error.localizedDescription)
        }
        
        if statusCode == 200 {
            if let content = content?.lowercased() {
                for phrase in unavailablePhrases {
                    if content.contains(phrase) {
                        print("Found: \(phrase)")
                        result = false
                        break
                    }
                }
                if !confirmationPhrases.isEmpty && result == true {
                    for phrase in confirmationPhrases {
                        if !content.contains(phrase) {
                            print("Not Found: \(phrase)")
                            result = false
                        }
                    }
                }
                if result {
                    print("Hit!")

                    if enableLogging {
                        writeLog(for: content, of: url)
                    }
                    if retailer.soundEnabled {
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_UserPreferredAlert))
                    }
                }
            } else { result = false }
        } else { result = false }
        
        return result
    }
    
    func writeLog(for contents: String, of url: URL) {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let supportPath = paths[0].appending(component: "com.mac-anu.Switch-2-Stock-Checker")
        let dateFormat = Date.ISO8601FormatStyle(dateSeparator: .omitted, dateTimeSeparator: .space, timeSeparator: .omitted, includingFractionalSeconds: false, timeZone: TimeZone.current)
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
