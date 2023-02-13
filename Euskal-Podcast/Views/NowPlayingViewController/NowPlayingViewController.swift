//
//  NowPlayingViewController.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-09.
//

import UIKit

class NowPlayingViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        playPauseAction()
    }
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    
    @IBAction func closeViewButtonTapped(_ sender: Any) {
        closeView()
    }
    
    // MARK: - Properties
    
    var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                playPauseButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            } else {
                playPauseButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            }
        }
    }
    var currentEpisode: EpisodeXML? {
        didSet {
            if let currentEpisode = currentEpisode {
                episodeTitleLabel.text = currentEpisode.title
            }
        }
    }
    
    // Notification Center.
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotificationsObservers()
    }
    
    private func setupNotificationsObservers() {
        notificationCenter.addObserver(self, selector: #selector(songPlaying),
                                       name: Notification.Name(rawValue: "SongPlaying"), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(songPause),
                                       name: Notification.Name(rawValue: "SongPause"), object: nil)
    }
    
    private func playPauseAction() {
        if isPlaying {
            AudioManager.shared.pauseSong()
        } else {
            AudioManager.shared.playSong()
        }
    }
    
    private func closeView() {
        AudioManager.shared.pauseSong()
        
        let notification: Notification = Notification(name: Notification.Name(rawValue: "HideNowPlayingView"))
        notificationCenter.post(notification)
    }
    
    @objc private func songPlaying() {
        isPlaying = true
        
        if let episode = AudioManager.shared.episode {
            currentEpisode = episode
        }
    }
    
    @objc private func songPause() {
        isPlaying = false
    }
    
}
