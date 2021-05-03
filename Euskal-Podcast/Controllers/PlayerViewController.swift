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
    let urlString: String = "https://www.ivoox.com/miseriaren-adarrak-xenpelarren-bertso-sorta_mf_50074712_feed_1.mp3"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playPauseButton.setTitle("Stop", for: .normal)
        
        self.setupPlayer()
    }
    
    ///
    /// Setup the AVPlayer.
    ///
    private func setupPlayer() {
        guard let url: URL = URL(string: self.urlString) else { return }
        
        let asset = AVAsset(url: url)
        self.playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: playerItem)
        
        self.player?.volume = 1.0
    }
    
    ///
    /// Play or Pause the media file.
    ///
    private func playPauseAction() {
        if isPlaying {
            self.playPauseButton.setTitle("Pause", for: .normal)
            self.player?.pause()
        } else {
            self.playPauseButton.setTitle("Play", for: .normal)
            self.player?.play()
        }
        
        self.isPlaying.toggle()
    }

}
