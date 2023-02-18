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
    var program: Program?
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
    
    func playSong(episode: Episode, program: Program) {
        guard let episodeAudioURL: URL = URL(string: episode.audioFileURL) else { return }
        
        self.episode = episode
        self.program = program
        
        let asset = AVAsset(url: episodeAudioURL)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        guard let player = player else { return }

        player.volume = 1.0
        
        totalDurationString = episode.getDurationFormatted()
        
        player.play()
        
        notifyShowNowPlayingView()
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
    
    func fastBackward15() {
        guard let player = player else { return }
        
        let seekDuration: Float64 = 15
        
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        
        var newTime = playerCurrentTime - seekDuration
        if newTime < 0 {
            newTime = 0
        }
        
        let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player.seek(to: time2) { success in
            self.notifySeekFinished()
        }
    }
    
    func fastForward15() {
        guard let player = player,
              let duration = player.currentItem?.duration else { return }
        
        let seekDuration: Float64 = 15
        
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        
        let newTime = playerCurrentTime + seekDuration
        if newTime < CMTimeGetSeconds(duration) {
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player.seek(to: time2) { success in
                self.notifySeekFinished()
            }
        }
        
    }
    
    func seekAudioTo(position: Double) {
        guard let player = player,
              let episode = episode else { return }
        
        let time = episode.getDurationInSeconds() * position
        player.seek(to: CMTime(value: CMTimeValue(time * 1000), timescale: 1000)) { success in
            self.notifySeekFinished()
        }
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
    
    func notifySeekFinished() {
        let notification = Notification(name: .seekFinished)
        notificationCenter.post(notification)
    }
    
    func isPlaying() -> Bool {
        guard let player = player else { return false }
        
        return (player.timeControlStatus == AVPlayer.TimeControlStatus.playing)
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
        nowPlayingInfo[MPMediaItemPropertyArtist] = program?.title
        
        // Image.
        var programImage: UIImage? = UIImage(systemName: "exclamationmark.triangle")
        
        if let program = program,
           let imageURL: URL = URL(string: program.imageURL) {
            let tempUIImageView: UIImageView = UIImageView()
            tempUIImageView.kf.setImage(with: imageURL)
            
            programImage = tempUIImageView.image
        }
        if let image = programImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { size in
                return image
            })
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
