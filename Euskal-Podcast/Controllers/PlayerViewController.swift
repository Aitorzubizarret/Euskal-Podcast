//
//  PlayerViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 02/05/2021.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        self.playPauseAction()
    }
    
    // MARK: - Properties
    
    var player: AVPlayer?
    var playerItem:AVPlayerItem?
    var isPlaying: Bool = false
    var isPlayerConfigured: Bool = false
    var episode: Episode?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playPauseButton.setTitle("Play", for: .normal)
        
    }
    
    ///
    /// Configure the Player.
    ///
    private func configurePlayer() {
        guard let receivedEpisode = self.episode,
              let episodeURL: URL = URL(string: receivedEpisode.mp3Url) else { return }
        
        let asset = AVAsset(url: episodeURL)
        self.playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        
        self.player?.volume = 1.0
        self.isPlayerConfigured = true
    }
    
    ///
    /// Play or Pause the media file.
    ///
    private func playPauseAction() {
        if isPlaying {
            self.playPauseButton.setTitle("Play", for: .normal)
            self.player?.pause()
        } else {
            if !isPlayerConfigured {
                self.configurePlayer()
            }
            self.playPauseButton.setTitle("Pause", for: .normal)
            self.player?.play()
        }
        
        self.isPlaying.toggle()
    }

}
