//
//  ProgramCollectionViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 16/05/2021.
//

import UIKit
import Kingfisher

class ProgramCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var podcast: Podcast? {
        didSet {
            guard let podcast = podcast else { return }
            
            // Title.
            titleLabel.text = podcast.title
            
            // Description.
            descriptionLabel.text = podcast.copyrightOwnerName
            
            // Image.
            if let iconURL: URL = URL(string: podcast.imageURL) {
                photoImageView.kf.setImage(with: iconURL)
            }
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    ///
    /// Setup the View.
    ///
    private func setupView() {
        // ImageView.
        photoImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        
        photoImageView.layer.cornerRadius = 4
        
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
}
