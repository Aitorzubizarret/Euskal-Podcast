//
//  PlayedEpisode.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-24.
//

import Foundation
import RealmSwift

class PlayedEpisode: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var episode: Episode?
    @objc dynamic var date: Date = Date()
    @objc dynamic var duration: Int = 0
    @objc dynamic var finished: Bool = false
}

extension PlayedEpisode {
    
    func getDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, yyyy/MM/dd - HH:mm:ss"
        dateFormatter.timeZone = TimeZone.init(identifier: "GMT")
        dateFormatter.locale = Locale(identifier: "eu")
        
        let playedDate: String = dateFormatter.string(from: date)
        
        return playedDate.uppercased()
    }
    
}
