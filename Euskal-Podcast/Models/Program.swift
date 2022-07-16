//
//  Program.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 12/05/2021.
//

import Foundation

struct Program: Codable {
    let Title: String
    let Description: String
    let DateStart: String
    let DateEnd: String
    let Seasons: [Season]
    let Episodes: [Episode]
    let URLs: [Media]
}
