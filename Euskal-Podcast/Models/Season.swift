//
//  Season.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 12/05/2021.
//

import Foundation

struct Season: Codable {
    let Title: String
    let Number: String
    let Description: String
    let DateStart: String
    let DateEnd: String
    let Episodes: [Episode]
}
