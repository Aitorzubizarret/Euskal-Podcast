//
//  Company.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 12/05/2021.
//

import Foundation

struct Company: Codable {
    let id: Int
    let name: String
    let programs: [Program]
}
