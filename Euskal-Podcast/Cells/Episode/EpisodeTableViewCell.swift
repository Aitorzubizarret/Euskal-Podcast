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
    
    var episode: EpisodeXML? {
        didSet {
            guard let receivedEpisode: EpisodeXML = episode else { return }
            
            // Published date.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, yyyy/MM/dd"
            dateFormatter.timeZone = TimeZone.init(identifier: "GMT")
            dateFormatter.locale = Locale(identifier: "eu")
            let episodeDate: String = dateFormatter.string(from: receivedEpisode.pubDate)
            releaseDateLabel.text = episodeDate.uppercased()
            
            // Title.
            titleLabel.text = receivedEpisode.title
            
            // Description.
            descriptionLabel.text = receivedEpisode.description
            
            // Duration.
            durationLabel.text = receivedEpisode.getDurationFormatted()
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
