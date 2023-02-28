//
//  NewEpisodeCollectionViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-28.
//

import UIKit
import Kingfisher

class NewEpisodeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var podcastNameLabel: UILabel!
    @IBOutlet weak var playPauseImageView: UIImageView!
    @IBOutlet weak var episodeDurationLabel: UILabel!
    
    // MARK: - Properties
    
    var episode: Episode? {
        didSet {
            guard let episode = episode else { return }
            
            pubDateLabel.text = episode.getPublishedDateFormatted()
            titleLabel.text = episode.title
            episodeDurationLabel.text = episode.duration.asTimeFormatted()
            
            if let podcast = episode.podcast,
               let iconURL: URL = URL(string: podcast.imageURL) {
                coverImageView.kf.setImage(with: iconURL)
                podcastNameLabel.text = podcast.title
            }
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupView() {
        coverImageView.layer.cornerRadius = 4
    }
    
}
