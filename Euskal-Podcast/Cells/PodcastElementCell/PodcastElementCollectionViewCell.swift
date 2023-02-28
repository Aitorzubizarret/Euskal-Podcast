//
//  PodcastElementCollectionViewCell.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta on 2023-02-28.
//

import UIKit
import Kingfisher

class PodcastElementCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    
    var podcast: Podcast? {
        didSet {
            guard let podcast = podcast else { return }
            
            if let imageURL: URL = URL(string: podcast.imageURL) {
                imageView.kf.setImage(with: imageURL)
            }
        }
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupView() {
        imageView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 4
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
    
}
