//
//  SourceTableViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 11/7/22.
//

import UIKit
import Kingfisher

class SourceTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    
    var source: Source? {
        didSet {
            guard let safeSource = source else { return }
            
            // Icon.
//            if let iconURL: URL = URL(string: safeSource.IconURL) {
//                iconImageView.kf.setImage(with: iconURL)
//            } else {
//                iconImageView.image = nil
//            }
            
            // Title.
            nameLabel.text = safeSource.Title
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
    /// Setup the view.
    ///
    private func setupView() {
        // Cell.
        selectionStyle = .none
        
        // ImageView.
        iconImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        iconImageView.layer.cornerRadius = 4
        
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
    
}
