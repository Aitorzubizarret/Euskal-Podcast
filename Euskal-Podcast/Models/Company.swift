//
//  Company.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 12/05/2021.
//

import Foundation

struct Company: Codable {
    let Title: String
    let Description: String
    let Programs: [ProgramXML]
    let URLs: [Media]
}
