//
//  Program.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 12/05/2021.
//

import Foundation

struct Program: Codable {
    let Id: Int
    let Name: String
    let Seasons: [Season]
    let IconURL: String
    let YoutubeURL: String
}
