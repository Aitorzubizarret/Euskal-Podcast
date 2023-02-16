//
//  NowPlayingViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-09.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var playPauseImageView: UIImageView!
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    
    @IBAction func closeViewButtonTapped(_ sender: Any) {
        closeView()
    }
    
    // MARK: - Properties
    
    var currentEpisode: Episode? {
        didSet {
            if let currentEpisode = currentEpisode {
                episodeTitleLabel.text = currentEpisode.title
            }
        }
    }
    
    var isPlaying: Bool = true {
        didSet {
            if isPlaying {
                playPauseImageView.image = UIImage(systemName: "pause.circle")
            } else {
                playPauseImageView.image = UIImage(systemName: "play.circle")
            }
        }
    }
    
    // Notification Center.
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNotificationsObservers()
    }
    
    private func setupView() {
        // Gesture Recognizers.
        let playPauseGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPauseAction))
        playPauseImageView.addGestureRecognizer(playPauseGR)
        playPauseImageView.isUserInteractionEnabled = true
        
        let viewTapGR = UITapGestureRecognizer(target: self, action: #selector(showPlayerFull))
        view.addGestureRecognizer(viewTapGR)
        view.isUserInteractionEnabled = true
    }
    
    private func setupNotificationsObservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(songPlaying),
                                       name: .songPlaying,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(songPause),
                                       name: .songPause,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(songPause),
                                       name: .audioFinished,
                                       object: nil)
    }
    
    private func closeView() {
        AudioManager.shared.pauseSong()
        
        let notification = Notification(name: .hideNowPlayingView)
        notificationCenter.post(notification)
    }
    
    @objc private func playPauseAction() {
        if AudioManager.shared.isPlaying() {
            AudioManager.shared.pauseSong()
            isPlaying = false
        } else {
            AudioManager.shared.playSong()
            isPlaying = true
        }
    }
    
    @objc private func showPlayerFull() {
        let notification = Notification(name: .showPlayerViewController)
        notificationCenter.post(notification)
    }
    
    @objc private func songPlaying() {
        if let episode = AudioManager.shared.episode {
            currentEpisode = episode
        }
        isPlaying = true
    }
    
    @objc private func songPause() {
        isPlaying = false
    }
    
}
