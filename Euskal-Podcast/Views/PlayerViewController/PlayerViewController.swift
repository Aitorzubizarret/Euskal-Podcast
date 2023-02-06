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
        playPauseAction()
    }
    
    // MARK: - Properties
    
    var coordinator: Coordinator
    var episodeXML: EpisodeXML?
    
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var isPlaying: Bool = false
    private var isPlayerConfigured: Bool = false
    
    // MARK: - Methods
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Player"
        
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        // Button.
        playPauseButton.backgroundColor = UIColor.blue
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.layer.cornerRadius = 25
        
        // ImageView.
        coverImageView.backgroundColor = UIColor.red
        coverImageView.layer.cornerRadius = 10
        
        // Check if we have an Episode.
        guard let episodeXML = episodeXML else { return }
        
        // Label
        titleLabel.text = episodeXML.title
        currentDurationTimeLabel.text = "00:00"
        totalDurationTimeLabel.text = "00:00"
        
        // Slider.
        durationSlider.minimumValue = 0
        durationSlider.maximumValue = 1
        durationSlider.setValue(0, animated: false)
        durationSlider.isContinuous = true
        
        configurePlayer(episode: episodeXML)
    }
    
    ///
    /// Configure the Player.
    ///
    private func configurePlayer(episode: EpisodeXML) {
        guard let episodeAudioURL: URL = URL(string: episode.audioFileURL) else { return }
        
        // Makes posible to listen to audio files even in "silent mode".
        try! AVAudioSession.sharedInstance().setCategory(.playback)
        
        let asset = AVAsset(url: episodeAudioURL)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        guard let safePlayer = player,
              let currentItem = safePlayer.currentItem else { return }

        safePlayer.volume = 1.0

        totalDurationTimeLabel.text = episode.duration

        safePlayer.addPeriodicTimeObserver(forInterval: CMTime.init(seconds: 1, preferredTimescale: 1), queue: .main) { time in
            let episodeDuration = CMTimeGetSeconds(currentItem.duration)
            let episodeCurrentTime = CMTimeGetSeconds(time)
            let progress: Float = Float(episodeCurrentTime/episodeDuration)
            self.durationSlider.setValue(progress, animated: true)

            self.displayCurrentTime(timeInSeconds: Int(time.seconds))
        }

        isPlayerConfigured = true
    }
    
    ///
    /// Play or Pause the media file.
    ///
    private func playPauseAction() {
        if isPlaying {
            playPauseButton.setTitle("Play", for: .normal)
            player?.pause()
        } else {
            playPauseButton.setTitle("Pause", for: .normal)
            player?.play()
        }
        
        isPlaying.toggle()
    }
    
    ///
    /// Calculate how much time has been played from the MP3 file and display it on a label.
    ///
    private func displayCurrentTime(timeInSeconds: Int) {
        // Label.
        var seconds: Int = 0
        var minutes: Int = 0
        
        seconds = timeInSeconds
        if seconds > 59 {
            minutes = seconds / 60
            seconds = seconds - (minutes * 60)
        }
        
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        currentDurationTimeLabel.text = timeString
    }
    
}
