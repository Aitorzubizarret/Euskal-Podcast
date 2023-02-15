//
//  Episode.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 05/05/2021.
//

import Foundation
import RealmSwift

class Episode: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var pubDate: Date = Date()
    @objc dynamic var explicit: String = ""
    @objc dynamic var audioFileURL: String = ""
    @objc dynamic var audioFileSize: String = ""
    @objc dynamic var duration: String = ""
    @objc dynamic var link: String = ""
    
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
    
    func getPublishedDateFormatter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, yyyy/MM/dd"
        dateFormatter.timeZone = TimeZone.init(identifier: "GMT")
        dateFormatter.locale = Locale(identifier: "eu")
        let episodeDate: String = dateFormatter.string(from: pubDate)
        
        return episodeDate.uppercased()
    }
    
    func convertToMb() -> String {
        return "3 Mb"
    }
    
}
