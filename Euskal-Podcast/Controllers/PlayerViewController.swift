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
    
    @IBOutlet weak var elementsStackView: UIStackView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBAction func durationSliderTapped(_ sender: Any) {
    }
    @IBOutlet weak var currentDurationTimeLabel: UILabel!
    @IBOutlet weak var totalDurationTimeLabel: UILabel!
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
        
        self.setupView()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        // Button.
        self.playPauseButton.backgroundColor = UIColor.blue
        self.playPauseButton.setTitle("Play", for: .normal)
        self.playPauseButton.layer.cornerRadius = 25
        
        // ImageView.
        self.coverImageView.backgroundColor = UIColor.red
        self.coverImageView.layer.cornerRadius = 10
        
        // Check if we have an Episode.
        guard let episode = self.episode else { return }
        
        // Label
        self.titleLabel.text = episode.name
        self.currentDurationTimeLabel.text = "00:00"
        self.totalDurationTimeLabel.text = "00:00"
        
        // Slider
        self.durationSlider.minimumValue = 0
        self.durationSlider.isContinuous = true
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
        
        guard let player = self.player,
              let currentItem = player.currentItem else { return }
        
        player.volume = 1.0
        let episodeDuration: CMTime = currentItem.asset.duration
        self.durationSlider.maximumValue = Float(CMTimeGetSeconds(episodeDuration))
        self.totalDurationTimeLabel.text = receivedEpisode.duration
        
        player.addPeriodicTimeObserver(forInterval: CMTime.init(seconds: 1, preferredTimescale: 1), queue: .main) { (time) in
            let episodeDuration = CMTimeGetSeconds(currentItem.duration)
            let episodeCurrentTime = CMTimeGetSeconds(time)
            let progress = episodeCurrentTime/episodeDuration
            self.durationSlider.setValue(Float(progress), animated: true)
            print("Progress : \(progress)")
            self.currentDurationTimeLabel.text = "\(progress)"
        }
        
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
