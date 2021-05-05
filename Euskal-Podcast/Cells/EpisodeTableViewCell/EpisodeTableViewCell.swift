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
            guard let receivedEpisode: Episode = self.episode else { return }
            
            self.titleLabel.text = receivedEpisode.name
            self.programNameLabel.text = receivedEpisode.program
            self.durationLabel.text = receivedEpisode.duration
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
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
        self.selectionStyle = .none
        
        // ImageView.
        self.coverImageView.backgroundColor = UIColor.blue
        self.coverImageView.layer.cornerRadius = 6
    }
}