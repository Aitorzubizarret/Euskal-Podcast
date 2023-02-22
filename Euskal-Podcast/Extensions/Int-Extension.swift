//
//  Int-Extension.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-22.
//

import Foundation

extension Int {
    
    func asTimeFormatted() -> String {
        var durationFormatted: String = ""
        
        let interval: TimeInterval = Double(self)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        if self >= 3600 {
            formatter.dateFormat = "HH:mm:ss"
        } else {
            formatter.dateFormat = "mm:ss"
        }
        durationFormatted = formatter.string(from: Date(timeIntervalSinceReferenceDate: interval))
        
        return durationFormatted
    }
    
}
