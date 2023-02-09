//
//  EpisodeTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 04/05/2021.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var bottomLineImageView: UIImageView!
    
    // MARK: - Properties
    
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
        bottomLineImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
}
