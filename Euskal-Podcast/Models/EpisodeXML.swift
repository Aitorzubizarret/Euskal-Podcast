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
    let pubDate: Date
    let explicit: String
    let audioFileURL: String
    let audioFileSize: String
    let duration: String
    let link: String
    
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
