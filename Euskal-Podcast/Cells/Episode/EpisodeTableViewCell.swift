//
//  EpisodeTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 04/05/2021.
//

import UIKit
import Kingfisher

protocol EpisodeCellDelegate {
    func playEpisode(rowAt: Int)
    func pauseEpisode(rowAt: Int)
}

class EpisodeTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverImageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var coverImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
    var delegate: EpisodeCellDelegate?
    var rowAt: Int?
    
    var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                playImageView.image = UIImage(systemName: "pause.circle")
            } else {
                playImageView.image = UIImage(systemName: "play.circle")
            }
        }
    }
    
    var coverImageURL: String = "" {
        didSet {
            if coverImageURL != "",
               let coverURL: URL = URL(string: coverImageURL) {
                coverImageView.kf.setImage(with: coverURL)
                coverImageViewWidthConstraint.constant = 60
                coverImageViewLeadingConstraint.constant = 20
            } else {
                coverImageViewWidthConstraint.constant = 0
                coverImageViewLeadingConstraint.constant = 0
            }
            contentView.layoutIfNeeded()
        }
    }
    var releaseDateText: String = "" {
        didSet {
            releaseDateLabel.text = releaseDateText
        }
    }
    var titleText: String = "" {
        didSet {
            titleLabel.text = titleText
        }
    }
    var descriptionText: String = "" {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }
    var durationText: String = "" {
        didSet {
            durationLabel.text = durationText
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
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        // Cell.
        selectionStyle = .none
        
        // UIImageView.
        coverImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        coverImageView.layer.cornerRadius = 4
        coverImageView.layer.borderWidth = 1
        coverImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        // Gesture Recognizer.
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(playPauseEpisode))
        playImageView.addGestureRecognizer(tapGR)
        playImageView.isUserInteractionEnabled = true
    }
    
    @objc private func playPauseEpisode() {
        guard let rowAt = rowAt else { return }
        
        if isPlaying {
            delegate?.pauseEpisode(rowAt: rowAt)
        } else {
            delegate?.playEpisode(rowAt: rowAt)
        }
    }
    
}
