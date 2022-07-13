//
//  Episode.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 05/05/2021.
//

import Foundation

struct Episode: Codable {
    let Title: String
    let Number: String
    let Description: String
    let PubDate: String
    let Duration: String
    let URLs: [Media]
}

//http://img.youtube.com/vi/VIDEOID/#.jpg
//
//http://img.youtube.com/vi/AAhrLlNeBiY/#.jpg
//http://img.youtube.com/vi/AAhrLlNeBiY/0.jpg
//https://www.youtube.com/watch?v=AAhrLlNeBiY
