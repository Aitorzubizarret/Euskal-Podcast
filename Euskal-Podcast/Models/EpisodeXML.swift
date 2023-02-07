//
//  EpisodeXML.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 1/2/23.
//

import Foundation

struct EpisodeXML: Codable {
    let title: String
    let description: String
    // let image: String
    let pubDate: String
    let explicit: String
    let audioFileURL: String
    let audioFileSize: String
    let duration: String
    let link: String
    
    func getDurationInSeconds() -> Double {
        var durationInSeconds: Double = 0
        let durationArray = duration.components(separatedBy: ":")
        
        if durationArray.count > 0 {
            switch durationArray.count {
            case 1:
                if let seconds = Double(duration) {
                    durationInSeconds = seconds
                }
            case 2:
                if let minutes = Double(durationArray[0]),
                   let seconds = Double(durationArray[1]) {
                    durationInSeconds = (minutes * 60) + seconds
                }
            case 3:
                if let hours = Double(durationArray[0]),
                   let minutes = Double(durationArray[1]),
                   let seconds = Double(durationArray[2]) {
                    durationInSeconds = (hours * 3600) + (minutes * 60) + seconds
                }
            default:
                print("Too long")
            }
        }
        
        return durationInSeconds
    }
    
    func getDurationFormatted() -> String {
        var durationFormatted: String = ""
        
        if let durationInSecs = Double(duration) {
            let interval: TimeInterval = durationInSecs
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            if durationInSecs >= 3600 {
                formatter.dateFormat = "HH:mm:ss"
            } else {
                formatter.dateFormat = "mm:ss"
            }
            durationFormatted = formatter.string(from: Date(timeIntervalSinceReferenceDate: interval))
        } else {
            durationFormatted = duration
        }
        
        return durationFormatted
    }
    
    func convertToMb() -> String {
        return "3 Mb"
    }
    
}
