//
//  Company.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 12/05/2021.
//

import Foundation

struct Company: Codable {
    let Id: Int
    let Name: String
    let Programs: [Program]
    let IconURL: String
}
