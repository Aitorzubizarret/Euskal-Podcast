//
//  Program.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 12/05/2021.
//

import Foundation

struct Program: Codable {
    let id: Int
    let name: String
    let seasons: [Season]
}
