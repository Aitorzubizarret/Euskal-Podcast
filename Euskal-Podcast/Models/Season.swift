//
//  Season.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 12/05/2021.
//

import Foundation

struct Season: Codable {
    let id: Int
    let name: String
    let dateStart: Date
    let dateEnd: Date
    let episodes: [Episode]
}
