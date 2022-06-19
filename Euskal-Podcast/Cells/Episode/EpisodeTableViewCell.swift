//
//  EpisodeTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 04/05/2021.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var programNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    // MARK: - Properties
    
    var episode: Episode? {
        didSet {
            guard let receivedEpisode: Episode = episode else { return }
            
            titleLabel.text = receivedEpisode.Name
            //self.programNameLabel.text = receivedEpisode
            durationLabel.text = receivedEpisode.Duration
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
        
        // ImageView.
        coverImageView.backgroundColor = UIColor.blue
        coverImageView.layer.cornerRadius = 6
    }
}
