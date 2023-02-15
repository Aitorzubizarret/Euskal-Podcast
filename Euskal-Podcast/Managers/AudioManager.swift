//
//  AudioManager.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-12.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer // Control music from the Lock Screen.

final class AudioManager {
    
    // MARK: - Property
    
    static var shared = AudioManager() // Singleton
    
    // Audio Player.
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    
    // Audio files data.
    var episode: Episode?
    var programName: String?
    var programImage: URL?
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
        
        setupRemoteControls()
    }
    
    func playSong(episode: Episode, programName: String, programImageString: String) {
        guard let episodeAudioURL: URL = URL(string: episode.audioFileURL),
              let programImageURL: URL = URL(string: programImageString) else { return }
        
        self.episode = episode
        self.programName = programName
        self.programImage = programImageURL
        
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
        
        updateRemoteDisplayInfo()
    }
    
    func playSong() {
        player?.play()
        isPlaying = true
        
        notifySongPlaying()
        
        updateRemoteDisplayInfo()
    }
    
    func pauseSong() {
        player?.pause()
        isPlaying = false
        
        notifySongPause()
        
        updateRemoteDisplayInfo()
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

// MARK: - Methods for Controlling Background Audio from Control Center.

extension AudioManager {
    
    func setupRemoteControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            if !self.isPlaying {
                self.player?.play()
                self.isPlaying = true
                
                notifySongPlaying()
                
                return .success
            }
            
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if self.isPlaying {
                self.player?.pause()
                self.isPlaying = false
                
                notifySongPause()
                
                return .success
            }
            
            return .commandFailed
        }
        
        // TODO: - Add logic for more commands.
        // - commandCenter.nextTrackCommand
        // - commandCenter.previousTrackCommand
        
    }
    
    func updateRemoteDisplayInfo() {
        // Define 'nowPlayingInfo' data.
        var nowPlayingInfo = [String: Any]()
        
        // Artist -> Podcast Program Title.
        nowPlayingInfo[MPMediaItemPropertyArtist] = self.programName
        
        // TODO: - Get image from the Program.
        // Image.
        if let image = UIImage(systemName: "exclamationmark.triangle") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        
        // Title.
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode?.title
        
        // Duration.
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = episode?.duration
        
        // Rate.
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        
        // Current time.
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime()
        
        // Set the metadata.
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
}
