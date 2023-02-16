//
//  PlayerViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 02/05/2021.
//

import UIKit

class PlayerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var elementsStackView: UIStackView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var durationSlider: UISlider!
    @IBAction func durationSliderTouchOn(_ sender: Any) {
        updateSliderPosition = false
    }
    @IBAction func durationSliderEndMoving(_ sender: Any) {
        let slider = sender as! UISlider
        seekAudioFilePosition(position: Double(slider.value))
    }
    
    @IBOutlet weak var currentDurationTimeLabel: UILabel!
    @IBOutlet weak var totalDurationTimeLabel: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        playPauseAction()
    }
    
    // MARK: - Properties
    
    var episode: Episode
    
    private var updateSliderPosition: Bool = true
    
    // Notification Center.
    private let notificationCenter = NotificationCenter.default
    
    private var timer: Timer?
    
    // MARK: - Methods
    
    init(episode: Episode) {
        self.episode = episode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        displayCurrentTime()
        setupNotificationsObservers()
        setupTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
    }
    
    private func setupView() {
        // Button.
        playPauseButton.layer.borderWidth = 1
        playPauseButton.layer.borderColor = UIColor.black.cgColor
        playPauseButton.layer.cornerRadius = 25
        if AudioManager.shared.isPlaying() {
            updateButtonPause()
        } else {
            updateButtonPlay()
        }
        
        // ImageView.
        coverImageView.backgroundColor = UIColor.red
        coverImageView.layer.cornerRadius = 10
        
        // Label
        titleLabel.text = episode.title
        currentDurationTimeLabel.text = "00:00"
        totalDurationTimeLabel.text = episode.getDurationFormatted()
        
        // Slider.
        durationSlider.minimumValue = 0
        durationSlider.maximumValue = 1
        durationSlider.setValue(0, animated: false)
        durationSlider.isContinuous = false
    }
    
    private func setupNotificationsObservers() {
        notificationCenter.addObserver(self, selector: #selector(updateButtonPause),
                                       name: Notification.Name(rawValue: "SongPlaying"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(updateButtonPlay),
                                       name: Notification.Name(rawValue: "SongPause"), object: nil)
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(displayCurrentTime), userInfo: nil, repeats: true)
    }
    
    private func playPauseAction() {
        if AudioManager.shared.isPlaying() {
            AudioManager.shared.pauseSong()
            updateButtonPlay()
        } else {
            AudioManager.shared.playSong()
            updateButtonPause()
        }
    }
    
    @objc private func updateButtonPlay() {
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    @objc private func updateButtonPause() {
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    ///
    /// Calculate how much time has been played from the MP3 file and display it on a label.
    ///
    @objc private func displayCurrentTime() {
        let episodeDuration: Int = Int(episode.duration) ?? 0
        let episodeCurrentTime: Int = AudioManager.shared.getCurrentPlayedTime()
        
        // Label.
        var seconds: Int = episodeCurrentTime
        var minutes: Int = 0
        
        if seconds > 59 {
            minutes = seconds / 60
            seconds = seconds - (minutes * 60)
        }
        
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        currentDurationTimeLabel.text = timeString
        
        // Slider.
        let progress: Float = Float(Float(episodeCurrentTime) / Float(episodeDuration))
        if updateSliderPosition {
            durationSlider.setValue(progress, animated: true)
        }
    }
    
    private func seekAudioFilePosition(position: Double) {
        let time = episode.getDurationInSeconds() * position
        
//        player?.seek(to: CMTime(value: CMTimeValue(time * 1000), timescale: 1000), completionHandler: { success in
//            if success {
//                self.updateSliderPosition = true
//            }
//        })
    }
    
}
