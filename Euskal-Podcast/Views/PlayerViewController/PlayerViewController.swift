//
//  PlayerViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 02/05/2021.
//

import UIKit
import Kingfisher

class PlayerViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var programNameLabel: UILabel!
    
    @IBOutlet weak var durationSlider: UISlider!
    @IBAction func sliderStartAction(_ sender: Any) {
        // Action : TouchDown.
        updateSliderPosition = false
    }
    @IBAction func sliderEndAction(_ sender: Any) {
        let slider = sender as! UISlider
        AudioManager.shared.seekAudioTo(position: Double(slider.value))
    }
    
    @IBOutlet weak var currentDurationTimeLabel: UILabel!
    @IBOutlet weak var totalDurationTimeLabel: UILabel!
    
    @IBOutlet weak var goBack15ImageView: UIImageView!
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var goForward15ImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var episode: Episode
    var podcast: Podcast
    
    private var updateSliderPosition: Bool = true
    
    // Notification Center.
    private let notificationCenter = NotificationCenter.default
    
    private var timer: Timer?
    
    // MARK: - Methods
    
    init(episode: Episode, podcast: Podcast) {
        self.episode = episode
        self.podcast = podcast
        
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
        // ImageView.
        pictureImageView.backgroundColor = UIColor.lightGray
        if let imageURL: URL = URL(string: podcast.imageURL) {
            pictureImageView.kf.setImage(with: imageURL)
        }
        
        pictureImageView.layer.borderWidth = 1
        pictureImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        pictureImageView.layer.masksToBounds = false
        
        pictureImageView.layer.shadowOffset = CGSize.init(width: 0, height: 4)
        pictureImageView.layer.shadowColor = UIColor.gray.cgColor
        pictureImageView.layer.shadowRadius = 4
        pictureImageView.layer.shadowOpacity = 0.5
        
        // Label
        titleLabel.text = episode.title
        programNameLabel.text = podcast.title
        currentDurationTimeLabel.text = "00:00"
        totalDurationTimeLabel.text = episode.duration != 0 ? episode.duration.asTimeFormatted() : AudioManager.shared.getAudioDurationInSeconds().asTimeFormatted()
        descriptionLabel.text = episode.descriptionText
        
        // Slider.
        durationSlider.minimumValue = 0
        durationSlider.maximumValue = 1
        durationSlider.setValue(0, animated: false)
        durationSlider.isContinuous = false
        durationSlider.setThumbImage(UIImage(systemName: "circlebadge.fill"), for: .normal)
        
        // Gesture Recognizers.
        let tapBack15GR = UITapGestureRecognizer(target: self, action: #selector(goBack15Action))
        goBack15ImageView.addGestureRecognizer(tapBack15GR)
        goBack15ImageView.isUserInteractionEnabled = true
        
        let tapPlayPauseGR = UITapGestureRecognizer(target: self, action: #selector(playPauseAction))
        playPauseImageView.addGestureRecognizer(tapPlayPauseGR)
        playPauseImageView.isUserInteractionEnabled = true
        
        let tapForward15GR = UITapGestureRecognizer(target: self, action: #selector(goForward15Action))
        goForward15ImageView.addGestureRecognizer(tapForward15GR)
        goForward15ImageView.isUserInteractionEnabled = true
        
        AudioManager.shared.isPlaying() ? updateButtonSongPlaying() : updateButtonSongPause()
    }
    
    private func setupNotificationsObservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(updateButtonSongPlaying),
                                       name: .songPlaying,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(updateButtonSongPause),
                                       name: .songPause,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(updateButtonSongFinished),
                                       name: .audioFinished,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(updateSlider),
                                       name: .seekFinished,
                                       object: nil)
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(displayCurrentTime), userInfo: nil, repeats: true)
    }
    
    @objc private func goBack15Action() {
        updateSliderPosition = false
        AudioManager.shared.fastBackward15()
    }
    
    @objc private func playPauseAction() {
        if AudioManager.shared.isPlaying() {
            AudioManager.shared.pauseSong()
            updateButtonSongPause()
        } else {
            AudioManager.shared.playSong()
            updateButtonSongPlaying()
        }
    }
    
    @objc private func goForward15Action() {
        updateSliderPosition = false
        AudioManager.shared.fastForward15()
    }
    
    @objc private func updateButtonSongPause() {
        playPauseImageView.image = UIImage(systemName: "play.fill")
    }
    
    @objc private func updateButtonSongPlaying() {
        playPauseImageView.image = UIImage(systemName: "pause.fill")
    }
    
    @objc private func updateButtonSongFinished() {
        playPauseImageView.image = UIImage(systemName: "play.fill")
    }
    
    ///
    /// Calculate how much time has been played from the MP3 file and display it on a label.
    ///
    @objc private func displayCurrentTime() {
        let episodeDuration: Int = episode.duration != 0 ? episode.duration : AudioManager.shared.getAudioDurationInSeconds()
        let episodeCurrentTime: Int = AudioManager.shared.getCurrentPlayedTime()
        
        // Label.
        var seconds: Int = episodeCurrentTime
        var minutes: Int = 0
        var hours: Int = 0
        
        if seconds > 59 {
            minutes = seconds / 60
            seconds = seconds - (minutes * 60)
        }
        
        if minutes > 59 {
            hours = minutes / 60
            minutes = minutes - (hours * 60)
        }
        
        var timeString = ""
        if hours > 0 {
            timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            timeString = String(format: "%02d:%02d", minutes, seconds)
        }
        
        //let timeString = String(format: "%02d:%02d", minutes, seconds)
        currentDurationTimeLabel.text = timeString
        
        // Slider.
        let progress: Float = Float(Float(episodeCurrentTime) / Float(episodeDuration))
        if updateSliderPosition {
            durationSlider.setValue(progress, animated: true)
        }
    }
    
    @objc private func updateSlider() {
        updateSliderPosition = true
        displayCurrentTime()
    }
    
}
