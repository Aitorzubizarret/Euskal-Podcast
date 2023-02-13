//
//  AudioManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-12.
//

import Foundation
import UIKit
import AVFoundation

final class AudioManager {
    
    // MARK: - Property
    
    static var shared = AudioManager() // Singleton
    
    // Audio Player.
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    // Audio files data.
    var episode: EpisodeXML?
    var isPlaying: Bool = false
    var totalDurationString = ""
    
    // Notification Center.
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Methods
    
    private init() {
        configurePlayer()
    }
    
    private func configurePlayer() {
        // Makes posible to listen to audio files even in "silent mode".
        try? AVAudioSession.sharedInstance().setCategory(.playback)
    }
    
    func playSong(episode: EpisodeXML) {
        guard let episodeAudioURL: URL = URL(string: episode.audioFileURL) else { return }
        
        self.episode = episode
        
        let asset = AVAsset(url: episodeAudioURL)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        guard let safePlayer = player,
              let currentItem = safePlayer.currentItem else { return }

        safePlayer.volume = 1.0
        
        totalDurationString = episode.getDurationFormatted()

//        safePlayer.addPeriodicTimeObserver(forInterval: CMTime.init(seconds: 1, preferredTimescale: 1), queue: .main) { time in
//            let episodeDuration = CMTimeGetSeconds(currentItem.duration)
//            let episodeCurrentTime = CMTimeGetSeconds(time)
//            let progress: Float = Float(episodeCurrentTime/episodeDuration)
//            if self.updateSliderPosition {
//                self.durationSlider.setValue(progress, animated: true)
//            }
//
//            self.displayCurrentTime(timeInSeconds: Int(time.seconds))
//        }
        
        notifyShowNowPlayingView()
        
        player?.play()
        isPlaying = true
        
        notifySongPlaying()
    }
    
    func playSong() {
        player?.play()
        isPlaying = true
        
        notifySongPlaying()
    }
    
    func pauseSong() {
        player?.pause()
        isPlaying = false
        
        notifySongPause()
    }
    
}

// MARK: - Methods that uses NotificationCenter.

extension AudioManager {
    
    func notifyShowNowPlayingView() {
        let notification: Notification = Notification(name: Notification.Name(rawValue: "ShowNowPlayingView"))
        notificationCenter.post(notification)
    }
    
    func notifyHideNowPlayingView() {
        let notification: Notification = Notification(name: Notification.Name(rawValue: "HideNowPlayingView"))
        notificationCenter.post(notification)
    }
    
    func notifySongPlaying() {
        let notification: Notification = Notification(name: Notification.Name(rawValue: "SongPlaying"))
        notificationCenter.post(notification)
    }
    
    func notifySongPause() {
        let notification: Notification = Notification(name: Notification.Name(rawValue: "SongPause"))
        notificationCenter.post(notification)
    }
    
}
