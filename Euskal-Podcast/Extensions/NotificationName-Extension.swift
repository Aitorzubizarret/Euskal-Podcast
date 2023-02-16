//
//  NotificationName-Extension.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-16.
//

import Foundation

extension Notification.Name {
    static let showPlayerViewController = Notification.Name("showPlayerViewController")
    static let showNowPlayingView = Notification.Name("showNowPlayingView")
    static let hideNowPlayingView = Notification.Name("hideNowPlayingView")
    static let songPlaying = Notification.Name("songPlaying")
    static let songPause = Notification.Name("songPause")
}
