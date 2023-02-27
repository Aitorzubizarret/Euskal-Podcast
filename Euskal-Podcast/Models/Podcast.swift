//
//  Podcast.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-25.
//

import Foundation
import RealmSwift

class Podcast: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var channelId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var explicit: String = ""
    @objc dynamic var language: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var copyright: String = ""
    @objc dynamic var copyrightOwnerName: String = ""
    @objc dynamic var copyrightOwnerEmail: String = ""
    let episodes = List<Episode>()
}

extension Podcast {
    
    func getLastEpisodesPubDateFormatted() -> String {
        // Get last episode.
        let lastEpisode = episodes.max { $0.pubDate < $1.pubDate }
        
        if let lastEpisode = lastEpisode {
            // Get lastEpisodes PubDate.
            let lastEpisodePubDate = lastEpisode.pubDate
            
            // Formatter.
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .short
            formatter.locale = Locale(identifier: "eu")
            
            let relativeDate = formatter.localizedString(for: lastEpisodePubDate, relativeTo: Date())
            
            return relativeDate
        } else {
            return "-"
        }
    }
    
}
