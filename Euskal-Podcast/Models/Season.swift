//
//  Season.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 12/05/2021.
//

import Foundation

struct Season: Codable {
    let Id: Int
    let Name: String
    let Number: Int
    let DateStart: String
    let DateEnd: String?
    let Episodes: [Episode]
}
