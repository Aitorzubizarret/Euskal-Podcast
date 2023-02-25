//
//  PlayedEpisodeTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-25.
//

import UIKit
import Kingfisher

class PlayedEpisodeTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var playedDateLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var podcastNameLabel: UILabel!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    var playedDateFormatted: String = "" {
        didSet {
            playedDateLabel.text = playedDateFormatted
        }
    }
    var pictureURL: String = "" {
        didSet {
            if let pictureURL: URL = URL(string: pictureURL) {
                pictureImageView.kf.setImage(with: pictureURL)
            }
        }
    }
    var episodeName: String = "" {
        didSet {
            episodeNameLabel.text = episodeName
        }
    }
    var podcastName: String = "" {
        didSet {
            podcastNameLabel.text = podcastName
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
}
