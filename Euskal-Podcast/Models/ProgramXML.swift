//
//  ProgramXML.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 1/2/23.
//

import Foundation

struct ProgramXML: Codable {
    let title: String
    let description: String
    let category: String
    let imageURL: String
    let explicit: String
    let language: String
    let author: String
    let link: String
    let copyright: String
    let copyrightOwnerName: String
    let copyrightOwnerEmail: String
    let episodes: [EpisodeXML]
}
