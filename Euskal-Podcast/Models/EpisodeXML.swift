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
    
    func convertToMb() -> String {
        return "3 Mb"
    }
    
}
