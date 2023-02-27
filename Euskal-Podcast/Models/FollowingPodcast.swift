//
//  FollowingPodcast.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-27.
//

import Foundation
import RealmSwift

class FollowingPodcast: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var podcast: Podcast?
    @objc dynamic var date: Date = Date()
}
