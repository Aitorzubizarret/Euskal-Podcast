//
//  Channel.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-20.
//

import Foundation
import RealmSwift

class Channel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var urlAddress: String = ""
    @objc dynamic var appendDate: Date = Date()
    @objc dynamic var downloaded: Bool = false
}
