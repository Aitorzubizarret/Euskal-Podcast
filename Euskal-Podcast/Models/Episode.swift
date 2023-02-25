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
    @objc dynamic var duration: Int = 0
    @objc dynamic var link: String = ""
    @objc dynamic var podcast: Podcast?
    
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
