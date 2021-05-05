//
//  Episode.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 05/05/2021.
//

import Foundation

struct Episode: Codable {
    let name: String
    let program: String
    let mp3Url: String
    let duration: String
}
