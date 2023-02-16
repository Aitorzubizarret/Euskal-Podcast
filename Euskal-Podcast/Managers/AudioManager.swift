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
    var totalDurationString = ""
    
    // Notification Center.
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Methods
    
    private init() {
        configurePlayer()
        setupNotificationsObservers()
    }
    
    private func setupNotificationsObservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(audioFinished),
                                       name: .AVPlayerItemDidPlayToEndTime,
                                       object: nil)
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
        
        notifySongPlaying()
        
        updateRemoteDisplayInfo()
    }
    
    func playSong() {
        player?.play()
        
        notifySongPlaying()
        
        updateRemoteDisplayInfo()
    }
    
    func pauseSong() {
        player?.pause()
        
        notifySongPause()
        
        updateRemoteDisplayInfo()
    }
    
    func getEpisodeId() -> String {
        guard let episode = episode else { return "" }
        return episode.id
    }
    
    func getCurrentPlayedTime() -> Int {
        guard let currentItem = playerItem else { return 0 }
        
        // Int or Float64
        let currentTimeInSeconds: Int = Int(CMTimeGetSeconds(currentItem.currentTime()))
        return currentTimeInSeconds
    }
    
    @objc private func audioFinished() {
        notifySongPause()
        updateRemoteDisplayInfo()
    }
    
}

// MARK: - Methods that uses NotificationCenter.

extension AudioManager {
    
    func notifyShowNowPlayingView() {
        let notification = Notification(name: .showNowPlayingView)
        notificationCenter.post(notification)
    }
    
    func notifyHideNowPlayingView() {
        let notification = Notification(name: .hideNowPlayingView)
        notificationCenter.post(notification)
    }
    
    func notifySongPlaying() {
        let notification = Notification(name: .songPlaying)
        notificationCenter.post(notification)
    }
    
    func notifySongPause() {
        let notification = Notification(name: .songPause)
        notificationCenter.post(notification)
    }
    
    func notifySongFinished() {
        let notification = Notification(name: .audioFinished)
        notificationCenter.post(notification)
    }
    
    func isPlaying() -> Bool {
        if let player = player {
            if player.timeControlStatus == AVPlayer.TimeControlStatus.playing {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}

// MARK: - Methods for Controlling Background Audio from Control Center.

extension AudioManager {
    
    func setupRemoteControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [unowned self] event in
            if !isPlaying() {
                self.player?.play()
                notifySongPlaying()
                
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
            if isPlaying() {
                self.player?.pause()
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
